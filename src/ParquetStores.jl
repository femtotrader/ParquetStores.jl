module ParquetStores

    export ParquetStore, libraries, create_library, library
    export symbols

    using Parquet2

    const EXTENSION = ".parquet"

    struct ParquetLibrary
        root_path
        key

        function ParquetLibrary(root_path, key)
            key = replace(key, "." => Base.Filesystem.path_separator)
            new(root_path, key)
        end
    end

    function _path(lib::ParquetLibrary)
        return joinpath(lib.root_path, lib.key)
    end

    function symbols(lib::ParquetLibrary)
        path = joinpath(lib.root_path, lib.key)
        symbols = String[]
        for fname in readdir(path)
            if endswith(fname, EXTENSION)
                symbol, _ = splitext(fname)
                push!(symbols, symbol)
            end
        end
        return symbols
    end

    function _symbol_path(lib::ParquetLibrary, symbol)
        joinpath(_path(lib), symbol * EXTENSION)
    end

    function Base.read(lib::ParquetLibrary, symbol)
        path = _symbol_path(lib, symbol)
        ds = Parquet2.Dataset(path)
        return ds
    end

    struct LibraryAccessor
        root_path
    end

    function Base.getindex(ps::LibraryAccessor, key::String)
        return ParquetLibrary(ps.root_path, key)
    end

    struct ParquetStore
        root_path
    end

    function libraries(ps::ParquetStore)
        libs = Set{String}()
        n_root = length(splitpath(ps.root_path))
        for (root, dirs, files) in walkdir(ps.root_path)
            root = splitpath(root)
            if length(dirs) == 0
                for file in files
                    lib = root[1+n_root:end]
                    lib = join(lib, ".")
                    push!(libs, lib)
                end
            end
        end
        return libs
    end

    function create_library(ps::ParquetStore, lib)
        lib = replace(lib, "." => Base.Filesystem.path_separator)
        lib = joinpath(ps.root_path, lib)
        mkpath(lib)
    end

    function library(ps::ParquetStore)
        return LibraryAccessor(ps.root_path)
    end

end
