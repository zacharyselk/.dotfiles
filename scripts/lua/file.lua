dofile("lua/utility.lua");


-- File Module ------------------------------------------------------------------------------------
function file_exists(filename)
  parameter_types(filename, "string");

  local f = io.open(filename, "rb");
  if f then
    f:close();
    return true;
  else
    return false;
  end
end

function read_file(filename)
  parameter_types(filename, "string");

  assert(file_exists(filename), string.format("File '%s' does not exist", filename));
  local f = assert(io.open(filename, "rb"));
  local contents = assert(f:read("*a"));
  f:close()
  return contents
end

function read_file_lines(filename)
  parameter_types(filename, "string");

  assert(file_exists(filename), string.format("File '%s' does not exist", filename));
  return split_string(read_file(filename), "\n");
end

function write_file(filename, contents)
  parameter_types(filename, "string", contents, "string");

  local f = assert(io.open(filename, "wb"));
  f:write(contents);
  f:flush();
  f:close();
end
---------------------------------------------------------------------------------------------------
