dofile("lua/environment.lua");
dofile("lua/utility.lua");


-- Package Module ---------------------------------------------------------------------------------
local function prompt(msg)
  parameter_types(msg, "string");

  io.write(msg.." [Y/n] ");
  local response = io.read("*l");
  print('"'..response..'"');
  response = string.gsub(response, "\n", "");
  if (response:lower() == "y" or response == "") then
    return true;
  else
    return false;
  end
end

local function install_package_apt(package)
  parameter_types(package, "string");

  print(run_command("sudo apt install -y "..package));
end

local function install_package_apt_get(package)
  parameter_types(package, "string");

  print(run_command("sudo apt-get install -y "..package));
end

local function install_package_brew(package)
  parameter_types(package, "string");

  print(run_command("brew install "..package));
end

local function install_package_yum(package)
  parameter_types(package, "string");

  print(run_command("sudo yum install -y "..package));
end

function install_package(package, environment_variables)
  parameter_types(package, "string", environment_variables, "table");

  print("Installing "..package);
  local pm = assert(environment_variables["DEFAULT_PACKAGE_MANAGER"], "No default package manager found");
  if     (pm == "apt") then install_package_apt(package);
  elseif (pm == "apt-get") then install_package_apt_get(package);
  elseif (pm == "brew") then install_package_brew(package);
  elseif (pm == "yum") then install_package_yum(package);
  else print(string.format("Error: Package manager '%s' is not supported", pm));
  end
end

function install_bat(environment_variables)
  parameter_types(environment_variables, "table");

  if (check_for_command("bat")) then
    return;
  end
  if (not prompt("Install Bat?")) then
    return;
  end

  local os_name = environment_variables["OS_NAME"];
  if (os_name) then os_name = os_name:lower() end

  if (os_name == "ubuntu") then
    local command = [[
    cd ~/.tmp_build &&\
    curl -s https://api.github.com/repos/sharkdp/bat/releases/latest \
      | grep "browser_download_url.*bat_.*amd64.deb" \
      | sed "s/\"\(.*\)\".*\"\(.*\)\"/\2/g" \
      | wget -qi - && \
    sudo dpkg -i bat*amd64.deb
    ]];
    print(run_command(command));
  else
    install_package("bat", environment_variables);
  end
  if (not check_for_command("bat")) then
    print("Install failed!");
  end
end

function install_docker(environment_variables)
  parameter_types(environment_variables, "table");

  if (not prompt("Install Docker?")) then
    return;
  end

  assert(0, "TODO");
end

function install_entr(environment_variables)
  parameter_types(environment_variables, "table");

  if (check_for_command("entr")) then
    return;
  end
  if (not prompt("Install entr?")) then
    return;
  end

  install_package("entr", environment_variables);
  if (not check_for_command("entr")) then
    print("Install failed!");
  end
end

function install_exa(environment_variables)
  parameter_types(environment_variables, "table");

  if (check_for_command("exa")) then
    return;
  end
  if (not prompt("Install exa?")) then
    return;
  end

  install_package("exa", environment_variables);
  if (not check_for_command("exa")) then
    print("Install failed!");
  end
end

function install_fzf(environment_variables)
  parameter_types(environment_variables, "table");

  if (check_for_command("fzf")) then
    return;
  end
  if (not prompt("install fzf?")) then
    return;
  end

  install_package("fzf", environment_variables);
  if (not check_for_command("fzf")) then
    print("install failed!");
  end
end

function install_github_cli(environment_variables)
  parameter_types(environment_variables, "table");

  if (check_for_command("gh")) then
    return;
  end
  if (not prompt("install GitHub CLI?")) then
    return;
  end

  install_package("gh", environment_variables);
  if (not check_for_command("gh")) then
    print("install failed!");
  end
end

function install_neovim(environment_variables)
  parameter_types(environment_variables, "table");

  if (check_for_command("nvim")) then
    return;
  end
  if (not prompt("Install NeoVim?")) then
    return;
  end

  local pm = assert(environment_variables["DEFAULT_PACKAGE_MANAGER"], "No default package manager found");
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

function install_syncthing(environment_variables)
  parameter_types(environment_variables, "table");

  if (not prompt("Install Syncthing?")) then
    return;
  end

  assert(0, "TODO");
end

function install_all_packages(environment_variables)
  parameter_types(environment_variables, "table");

  install_bat(environment_variables);
  install_docker(environment_variables);
  install_entr(environment_variables);
  install_exa(environment_variables);
  install_fzf(environment_variables);
  install_github_cli(environment_variables);
  install_neovim(environment_variables);
  install_syncthing(environment_variables);
end
---------------------------------------------------------------------------------------------------
