#!/usr/bin/env lua

dofile("lua/environment.lua");
dofile("lua/file.lua");
dofile("lua/package.lua");
dofile("lua/rc.lua");
dofile("lua/string.lua");
dofile("lua/utility.lua");


-- Environment-Variable Module --------------------------------------------------------------------
local function check_environment_variable(variable_name, environment_variables, modified_variables)
  parameter_types(variable_name, "string", environment_variables, "table", modified_variables, "table");

  local environment_variable = os.getenv(variable_name);
  if (not environment_variable) then
    local suggestion = get_suggestion(variable_name, environment_variables);
    if (suggestion) then
      io.write(string.format("%s is not set! Please enter it now: [%s] ", variable_name, suggestion));
      environment_variable = io.read("*l");
      if (environment_variable == "") then
        environment_variable = suggestion;
      end
    else
      io.write(string.format("%s is not set! Please enter it now: ", variable_name));
      environment_variable = io.read("*l");
    end
    modified_variables[variable_name] = environment_variable;
  end

  return environment_variable
end

local function check_environment_variables()
  local environment_variables = {};
  local modified_variables = {};
  environment_variables["HOME"] = check_environment_variable("HOME", environment_variables, modified_variables);
  environment_variables["OS_KERNEL"] = check_environment_variable("OS_KERNEL", environment_variables, modified_variables);
  environment_variables["OS_NAME"] = check_environment_variable("OS_NAME", environment_variables, modified_variables);
  environment_variables["OS_VERSION"] = check_environment_variable("OS_VERSION", environment_variables, modified_variables);
  environment_variables["DEFAULT_SHELL"] = check_environment_variable("DEFAULT_SHELL", environment_variables, modified_variables);
  environment_variables["DEFAULT_RC"] = check_environment_variable("DEFAULT_RC", environment_variables, modified_variables);
  environment_variables["DEFAULT_PACKAGE_MANAGER"] = check_environment_variable("DEFAULT_PACKAGE_MANAGER", environment_variables, modified_variables);

  if (next(modified_variables) ~= nil) then
    for k,v in pairs(modified_variables) do
      print(string.format("\nAssiging: %s -> %s", k, v));
      add_rc_environment_variable(k, v, environment_variables);
    end
  end

  return environment_variables;
end

local function create_home_directories(environment_variables)
  parameter_types(environment_variables, "table");

  local home = assert(environment_variables["HOME"], "$HOME was not set!");
  local directories = {"bin", ".local", ".tmp_build"};
  for i,directory in ipairs(directories) do
    create_directory(home.."/"..directory);
  end
end

local function add_to_path(environment_variables)
  parameter_types(environment_variables, "table");

  local directories = {"$HOME/bin"};
  for i,directory in ipairs(directories) do
    append_to_path(directory, environment_variables);
  end
end

local function install_packages(environment_variables)
  parameter_types(environment_variables, "table");

  local packages = {};
  for i,package in ipairs(packages) do
    install_package(package, environment_variables);
  end
  install_all_packages(environment_variables);
end
---------------------------------------------------------------------------------------------------

local function main()
  local environment_variables = check_environment_variables();
  create_home_directories(environment_variables);
  add_to_path(environment_variables);
  install_packages(environment_variables);
end


main();
