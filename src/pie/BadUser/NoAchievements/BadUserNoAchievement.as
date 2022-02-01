package pie.BadUser.NoAchievements
{
	import Bezel.Bezel;
	import Bezel.BezelCoreMod;
	import Bezel.Lattice.Lattice;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Chris
	 */
	public class BadUserNoAchievement extends MovieClip implements BezelCoreMod
	{
		public function get VERSION():String {return "0.0.1";}
		public function get GAME_VERSION():String {return "1.1.2b";}
		public function get BEZEL_VERSION():String {return "2.0.0";}
		public function get MOD_NAME():String {return "BadUserNoAchievement";}
		
		CONFIG::debug
		public function get COREMOD_VERSION():String {return String(Math.random());}
		CONFIG::release
		public function get COREMOD_VERSION():String {return VERSION;}
		
		public function BadUserNoAchievement() 
		{
		}
		
		public function loadCoreMod(lattice:Lattice):void
		{
			var game:String;
			if (lattice.doesFileExist("com/giab/games/gcfw/Main.class.asasm"))
			{
				game = "gcfw";
			}
			else
			{
				game = "gccs/steam";
			}
			var offset:int = lattice.findPattern("com/giab/games/"+ game + "/Main.class.asasm", /(set|init)property.*steamworks/);
			if (offset == -1)
			{
				throw new Error("Could not apply");
			}
			lattice.patchFile("com/giab/games/"+ game + "/Main.class.asasm", offset-3, 2, "pushnull");
			
			offset = lattice.findPattern("com/giab/games/" + game + "/Main.class.asasm", /initproperty.*isSteamworksInitiated/);
			if (offset == -1)
			{
				throw new Error("Could not apply");
			}
			lattice.patchFile("com/giab/games/" + game + "/Main.class.asasm", offset-5, 0, ' \
				findpropstrict QName(PackageNamespace(""),"steamworks") \n \
				getlocal0 \n \
				getproperty QName(PackageNamespace(""), "bezel") \n \
				pushstring "BadUserNoAchievement" \n \
				callproperty QName(PackageNamespace(""), "getModByName"), 1 \n \
				getproperty QName(PackageNamespace(""), "loaderInfo") \n \
				getproperty QName(PackageNamespace(""), "applicationDomain") \n \
				pushstring "pie.BadUser.NoAchievements.FakeSteamWorks" \n \
				callproperty QName(PackageNamespace(""), "getDefinition"), 1 \n \
				construct 0 \n \
				setproperty QName(PackageNamespace(""),"steamworks")');
			
			offset = lattice.findPattern("com/giab/games/" + game + "/Main.class.asasm", /trait slot.*steamworks/);
			if (offset == -1)
			{
				throw new Error("Could not apply");
			}
			lattice.patchFile("com/giab/games/" + game + "/Main.class.asasm", offset-1, 1, 
								"trait slot QName(PackageNamespace(\"\"), \"steamworks\") slotid 1 type QName(PackageNamespace(\"\"), \"Object\") end");
		}
		
		public function unload():void {}
		
		public function bind(bezel:Bezel, objects:Object):void
		{
			bezel.getSettingManager(MOD_NAME).registerBoolean("Disable Steam Integration", function(v:Boolean):void{
				FakeSteamWorks.setBlocking(v);
			}, true, "May require restart");

			FakeSteamWorks.setBlocking(bezel.getSettingManager(MOD_NAME).retrieveBoolean("Disable Steam Integration"));
		}
		
	}
	
}
