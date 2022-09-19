dofile("lua/string.lua");
dofile("lua/utility.lua");


local MACOS_VERSION_NAMES = {
  ["1.2"] = "Mac OS X Kodiak",
  ["1.3"] = "Mac OS X Cheetah",
  ["1.4"] = "Mac OS X Puma",
  ["5"] = "Mac OS X Puma",
  ["6"] = "Mac OS X Jaguar",
  ["7"] = "Mac OS X Panther",
  ["8"] = "Mac OS X Tiger",
  ["9"] = "Mac OS X Leopard",
  ["10"] = "Mac OS X Snow Leopard",
  ["11"] = "Mac OS X Lion",
  ["12"] = "OS X Mountain Lion",
  ["13"] = "OS X Mavericks",
  ["14"] = "OS X Yosemite",
  ["15"] = "OS X El Capitan",
  ["16"] = "macOS Sierra",
  ["17"] = "macOS High Sierra",
  ["18"] = "macOS Mojave",
  ["19"] = "macOS Catalina",
  ["20"] = "macOS Big Sur",
  ["21"] = "macOS Monterey",
  ["22"] = "macOS Ventura"
};

local function probe_for_macos()
  local output = run_command("ls /Applications");
  if (count_lines(output) > 1) then
    return true;
  else
    return false;
  end
end

local function probe_for_linux()
  local output = run_command("ls /proc");
  if (count_lines(output) > 1) then
    return true;
  else
    return false;
  end
end

local function probe_for_windows()
  local output = run_command("dir C:");
  if (count_lines(output) > 1) then
    return true;
  else
    return false;
  end
end

local function probe_for_unix_version()
  local output = run_command("uname -r");
  if (output) then
    return split_string(output, '\n')[1];
  else
    return nil;
  end
end

local function probe_for_macos_name(environment_variables)
  parameter_types(environment_variables, "table");

  local os_version = environment_variables["OS_VERSION"];
  if (not os_version) then
    os_version = probe_for_unix_version();
  end

  if (os_version) then
    for k,v in pairs(MACOS_VERSION_NAMES) do
      if (starts_with(os_version, k)) then
        return v;
      end
    end
  end

  return nil;
end

local function probe_for_macos_shell()
  local output = run_command("dscl . -read ~/ UserShell")
  if (starts_with(output, "UserShell: ")) then
    return string.sub(output, string.len("UserShell: ") + 1, string.len(output));
  else
    return nil;
  end
end

local function suggest_os_kernel(environment_variables)
  parameter_types(environment_variables, "table");

  if (probe_for_macos()) then
    return "Darwin";
  elseif (probe_for_linux()) then
    return "Linux";
  elseif (probe_for_windows()) then
    return "Windows";
  else
    return nil;
  end
end

local function suggest_os_name(environment_variables)
  parameter_types(environment_variables, "table");

  local os_kernel = environment_variables["OS_KERNEL"];
  if (not os_kernel) then
    return nil;
  end
  
  if (os_kernel:lower() == "darwin") then
    return probe_for_macos_name(environment_variables);
  elseif (os_kernel:lower() == "linux") then
    return probe_for_linux_name();
  elseif (os.kernel:lower() == "windows") then
    return nil;
  else
    return nil;
  end
end

local function suggest_os_version(environment_variables)
  parameter_types(environment_variables, "table");

  local os_kernel = environment_variables["OS_KERNEL"];
  if (not os_kernel) then
    return nil;
  end
  
  if (os_kernel:lower() == "darwin") then
    return probe_for_unix_version();
  elseif (os_kernel:lower() == "linux") then
    return probe_for_unix_version();
  elseif (os.kernel:lower() == "windows") then
    return nil;
  else
    return nil;
  end
end

local function suggest_default_shell(environment_variables)
  parameter_types(environment_variables, "table");

  local os_kernel = environment_variables["OS_KERNEL"];
  if (not os_kernel) then
    return nil;
  end
  
  if (os_kernel:lower() == "darwin") then
    return probe_for_macos_shell();
  elseif (os_kernel:lower() == "linux") then
    return nil;
  elseif (os.kernel:lower() == "windows") then
    return nil;
  else
    return nil;
  end
end

local function suggest_default_rc(environment_variables)
  parameter_types(environment_variables, "table");

  local default_shell = environment_variables["DEFAULT_SHELL"];
  local home = environment_variables["HOME"];
  if (not default_shell or not home) then
    return nil;
  end

  local shell_language = last_element(split_string(default_shell, '/'));
  if (shell_language == "bash") then
    return home.."/.bashrc";
  elseif (shell_language == "zsh") then
    return home.."/.zshrc";
  else
    return nil;
  end
 end

local function suggest_default_package_manager(environment_variables)
  parameter_types(environment_variables, "table");

  local os_kernel = environment_variables["OS_KERNEL"];
  if (not os_kernel) then
    return nil;
  end
  
  if (os_kernel:lower() == "darwin") then
    return "brew";
  elseif (os_kernel:lower() == "linux") then
    return nil;
  elseif (os.kernel:lower() == "windows") then
    return "choco";
  else
    return nil;
  end
end

local ENVIRONMENT_VARIABLE_SUGGESTION = {
  OS_KERNEL = suggest_os_kernel,
  OS_NAME = suggest_os_name,
  OS_VERSION = suggest_os_version,
  DEFAULT_SHELL = suggest_default_shell,
  DEFAULT_RC = suggest_default_rc,
  DEFAULT_PACKAGE_MANAGER = suggest_default_package_manager
};


function get_suggestion(variable, environment_variables)
  parameter_types(variable, "string", environment_variables, "table");

  local func = ENVIRONMENT_VARIABLE_SUGGESTION[variable];
  if (func) then
    return func(environment_variables);
  else
    return nil;
  end
end

function check_for_command(command)
  local output = run_command("which "..command);
  if (output == "") then
    return false;
  else
    return true;
  end
end
