
-- targets
PseudoTarget("try")
PseudoTarget("all", "try")

-- variables
conf = ScriptArgs["conf"] or "debug"
build_dir = ScriptArgs["build_dir"] or "build"
build_dir = PathJoin(build_dir, conf)
src_dir = "src"
test_dir = "test"

-- configure settings on creation
AddTool(function(settings)
	if conf == "debug" then
		settings.debug = 1
		settings.optimize = 0
	  settings.cc.flags:Add("-g")
	elseif conf == "release" then
		settings.debug = 0
		settings.optimize = 1
	end

	settings.cc.flags:Add("-Wall")
	settings.cc.flags:Add("-Wextra")
	settings.cc.flags_cxx:Add("--std=c++17")
	settings.cc.includes:Add(src_dir)
	settings.cc.Output = function(settings, input)
		input = input:gsub("^"..src_dir.."/", "")
		return PathJoin(PathJoin(build_dir, "obj"), PathBase(input))
	end
	settings.link.Output = function(settings, input)
		return PathJoin(build_dir, PathBase(input))
	end
end)

-- settings
settings = NewSettings()

-- add jobs
srcs = CollectRecursive(PathJoin(src_dir, "*.cpp"))
objs = Compile(settings, srcs)
bin = Link(settings, "try", objs)
AddDependency("try", bin)
