dofile("lua/utility.lua");


-- String Module ----------------------------------------------------------------------------------
function starts_with(str, prefix)
  parameter_types(str, "string", prefix, "string");

  return string.sub(str, 1, string.len(prefix)) == prefix;
end

function split_string(str, delim)
  parameter_types(str, "string", delim, "string|nil");

  if (delim == nil) then
    delim = "%s";
  end

  local split = {};
  for piece in string.gmatch(str, "([^"..delim.."]+)") do
    table.insert(split, piece);
  end

  return split;
end

function count_lines(str)
  parameter_types(str, "string");

  return #split_string(str, '\n');
end
---------------------------------------------------------------------------------------------------
