#!/usr/bin/env lua

local OS_KERNEL = nil
local OS_NAME = nil
local DEFAULT_SHELL = nil
local DEFAULT_RC = nil
local DEFAULT_PACKAGE_MANAGER = nil
local HOME = nil

-- String Module ----------------------------------------------------------------------------------
local function starts_with(str, prefix)
  return string.sub(str, 1, string.len(prefix)) == prefix;
end

local function split_string(str, delim)
  if (delim == nil) then
    delim = "%s";
  end

  local split = {};
  for piece in string.gmatch(str, "([^"..delim.."]+)") do
    table.insert(split, piece);
  end

  return split;
end
---------------------------------------------------------------------------------------------------


-- Utility Module ---------------------------------------------------------------------------------
local function get_timestamp()
  local date = os.date("%x");
  local time = os.date("%X");
  date = string.gsub(date, '/', '-');
  time = string.gsub(time, ':', '-');
  return date..'_'..time;
end

local function last_element(array)
  if (type(array) == "string") then
    return array:sub(-1, -1)
  elseif (type(array) == "table") then
    return array[#array];
  end
  return nil;
end

local function run_command(command)
  print("-- "..command);
  local output_file = io.popen(command);
  local output = output_file:read("*all");
  if (last_element(output) == '\n') then
    output = output:sub(1, -2);
  end
  output_file.close();
  return output;
end

local function create_directory(path)
  run_command(string.format("mkdir -p %s", path));
end
---------------------------------------------------------------------------------------------------


-- File Module ------------------------------------------------------------------------------------
local function file_exists(filename)
  local f = io.open(filename, "rb");
  if f then
    f:close();
  end

  return f ~= nil;
end

local function read_file(filename)
  if not file_exists(filename) then
    return {};
  end

  local f = assert(io.open(filename, "rb"));
  local contents = assert(f:read("a"));
  f:close()
  return contents
end

local function read_file_lines(filename)
  return split_string(read_file(filename), "\n");
end

local function write_file(filename, contents)
  local f = assert(io.open(filename, "wb"));
  f:write(contents);
  f:flush();
  f:close();
end
---------------------------------------------------------------------------------------------------


-- RC Module --------------------------------------------------------------------------------------
local function backup_rc()
  local command = string.format("cp %s %s", DEFAULT_RC, DEFAULT_RC..'_'..get_timestamp());
  run_command(command);
end

local function is_block_header(line)
  if (string.len(line) == 80 and string.gmatch(line, "#### [a-zA-Z0-9%._%-%s]+ ####") ~= nil) then
    return true;
  else
    return false;
  end
end

local function is_block_footer(line)
  if (line == string.rep("#", 80)) then
    return true;
  else
    return false;
  end
end

local function get_block_header_name(line)
  line = line:sub(6, -1);
  return string.gsub(line, " #+", "");
end

local function get_managed_blocks(filename)
  local blocks = {}
  local block = {}
  local lines = read_file_lines(filename);
  local reading_block = false;
  for line_number,line in ipairs(lines) do
    if (reading_block) then
      block[#block + 1] = line_number;
      if is_block_footer(line) then
        reading_block = false;
	blocks[#blocks + 1] = block;
	block = {};
      end
    elseif (is_block_header(line)) then
      reading_block = true;
      block[#block + 1] = line_number;
    end
  end

  return blocks
end

local function add_rc_environment_variable(variable, value)
  backup_rc();
  local export_variable = string.format('export %s="%s"', variable, value);
  local lines = read_file_lines(DEFAULT_RC);
  for i,v in ipairs(get_managed_blocks(DEFAULT_RC)) do 
    if (get_block_header_name(lines[v[1]]) == "Environement-Variables") then
      local export_exists = false;
      for j, block_line_number in pairs(v) do
        if (lines[block_line_number] == export_variable) then
          export_exists = true;
	  break;
        end
      end
      if (not export_exists) then
        table.insert(lines, v[#v], export_variable);
      end
    end
  end
  write_file(DEFAULT_RC, table.concat(lines, '\n'));
end

local function append_to_path(path)
  add_rc_environment_variable("PATH", string.format("$PATH:%s", path));
end

local function prepend_to_path(path)
  add_rc_environment_variable("PATH", string.format("%s:$PATH", path));
end
---------------------------------------------------------------------------------------------------


-- Package Module ---------------------------------------------------------------------------------
local function install_package_apt(package)
  print(run_command("sudo apt install -y "..package));
end

local function install_package_apt_get(package)
  print(run_command("sudo apt-get install -y "..package));
end

local function install_package_brew(package)
  print(run_command("brew install -y "..package));
end

local function install_package_yum(package)
  print(run_command("sudo yum install -y "..package));
end

local function install_package(package)
  print("Installing "..package);
  local pm = DEFAULT_PACKAGE_MANAGER;
  if     (pm == "apt") then install_package_apt(package);
  elseif (pm == "apt-get") then install_package_apt_get(package);
  elseif (pm == "brew") then install_package_brew(package);
  elseif (pm == "yum") then install_package_yum(package);
  else print(string.format("Error: Package manager '%s' is not supported", pm));
  end
end

local function install_neovim()
  local pm = DEFAULT_PACKAGE_MANAGER;
  local packages = "";
  if (pm == "apt") then 
    packages = "ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen";
  elseif (pm == "apt-get") then 
    packages = "ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen";
  elseif (pm == "brew") then
    packages = "ninja libtool automake cmake pkg-config gettext curl";
  elseif (pm == "yum") then
    packages = "ninja-build libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip patch gettext curl";
  else print(string.format("Error: Package manager '%s' is not supported", pm));
  end

  print("Installing Build Prerequisites for Neovim");
  install_package(packages);

  local git_repo = "https://github.com/neovim/neovim";
  local tmp_dir = "$HOME/.tmp_build";
  local build_dir = tmp_dir.."/neovim";
  local build_args = "CMAKE_BUILD_TYPE=RelWithDebInfo" 
  build_args = build_args..' CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.local/neovim"';

  run_command("cd $HOME/.tmp_build && rm -rf *");
  print("Cloning Neovim");
  print(run_command(string.format("cd %s && git clone %s", tmp_dir, git_repo)));

  print("Building Neovim");
  print(run_command(string.format("cd %s && make %s", build_dir, build_args)));
  print(run_command(string.format("cd %s && make install", build_dir)));
  append_to_path("$HOME/.local/neovim/bin");

  print("Cloning Neovim Config");
  print(run_command("cd $HOME/.config && git clone https://github.com/zacharyselk/nvim"));
end
---------------------------------------------------------------------------------------------------


-- Environment-Variable Module --------------------------------------------------------------------
local function get_default_shell()
  local os_kernel = string.lower(OS_KERNEL);
  local command = "";
  if (os_kernel == "linux") then
    command = "grep \"^$USER:\" /etc/passwd| rev | cut -d':' -f 1 | rev";
  elseif (os_kernel == "darwin") then
    ;
  elseif (os_kernel == "windows") then
    ;
  else
    print(string.format("Error: %s is not a vailid kernel type", OS_KERNEL));
    return;
  end
  
   return run_command(command);
end

local function check_environment_variable(variable_name, modified_variables)
  local environment_variable = os.getenv(variable_name);
  if (not environment_variable) then
    io.write(string.format("%s is not set! Please enter it now: ", variable_name));
    environment_variable = io.read("*l");
    modified_variables[variable_name] = environment_variable;
  end

  return environment_variable
end

local function check_environment_variables()
  local modified_variables = {};
  OS_KERNEL = check_environment_variable("OS_KERNEL", modified_variables);
  OS_NAME = check_environment_variable("OS_NAME", modified_variables);
  check_environment_variable("OS_VERSION", modified_variables);
  DEFAULT_SHELL = check_environment_variable("DEFAULT_SHELL", modified_variables);
  DEFAULT_RC = check_environment_variable("DEFAULT_RC", modified_variables);
  DEFAULT_PACKAGE_MANAGER = check_environment_variable("DEFAULT_PACKAGE_MANAGER", modified_variables);
  HOME = check_environment_variable("HOME", modified_variables);

  if (next(modified_variables) ~= nil) then
    for k,v in pairs(modified_variables) do
      print(string.format("\nAssiging: %s -> %s", k, v));
      add_rc_environment_variable(k, v);
    end
  end
end

local function create_home_directories()
  local directories = {"bin", ".local", ".tmp_build"};
  for i,directory in ipairs(directories) do
    create_directory(HOME.."/"..directory);
  end
end

local function add_to_path()
  local directories = {"$HOME/bin"};
  for i,directory in ipairs(directories) do
    append_to_path(directory);
  end
end

local function install_packages()
  local packages = {"git"};
  for i,package in ipairs(packages) do
    install_package(package);
  end
  install_neovim();
end
---------------------------------------------------------------------------------------------------

local function main()
  check_environment_variables();
  create_home_directories();
  add_to_path();
  install_packages();
end


main();
