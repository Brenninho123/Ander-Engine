package art.scripts;

import haxe.Json;
import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;

using StringTools;

// haxe -m art.scripts.FindMissingLibs --interp
class FindMissingLibs
{
	public static function convertToValidPath(s:String):String
		return s.replace('.', ',');

	public static function main()
	{
		var haxelibFolder = FileSystem.readDirectory('.haxelib');

		for (lib in haxelibFolder)
		{
			if (FileSystem.isDirectory('.haxelib/$lib'))
			{
				var version = File.getContent('.haxelib/$lib/.current');
				var haxelibFile:Dynamic = Json.parse(File.getContent('.haxelib/$lib/${convertToValidPath(version)}/haxelib.json'));

				var deps = Reflect.fields(haxelibFile.dependencies);

				if (deps.length > 0)
					trace('$lib($version)');

				for (dep in deps)
				{
					var depVer = Reflect.field(haxelibFile.dependencies, dep);

					var depString = '$dep($depVer)';

					var depStringAppend = '';

					if ((!FileSystem.exists('.haxelib/${convertToValidPath(dep)}/${convertToValidPath(depVer)}') && depVer != '')
						|| (!FileSystem.exists('.haxelib/${convertToValidPath(dep)}/') && depVer == ''))
					{
						depStringAppend += '| MISSING';

						if (File.getContent('hmm.json').contains(dep))
							depStringAppend += ' (hmm reinstall or hmm install should work)';
					}

					trace(' * $depString $depStringAppend');
				}
			}
		}
	}
}
