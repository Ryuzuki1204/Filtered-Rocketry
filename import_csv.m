function [mat] = import_csv(file_name)
    mat = readtable(file_name);
end