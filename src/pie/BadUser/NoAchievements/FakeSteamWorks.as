package pie.BadUser.NoAchievements 
{
	import flash.utils.getDefinitionByName;
	import Bezel.Bezel;
	import flash.system.System;

	/**
	 * ...
	 * @author Chris
	 */
	public class FakeSteamWorks 
	{
		internal static var self:FakeSteamWorks;
		private static var actualSteamworks:Object = null;
		private static var workaroundParam1:Object = null;
		private static var workaroundParam2:Boolean = false;
		public function FakeSteamWorks() 
		{
		}
		
		public function init(): Boolean { return true; }
		
		public function dispose(): void
		{
			if (actualSteamworks != null) {
				actualSteamworks.dispose();
				actualSteamworks = null;
			}
		}
		
		public function addOverlayWorkaround(thing:Object, thing2:Boolean): void
		{
		}
		
		public function setAchievement(thing:String):void
		{
			if (actualSteamworks != null)
			{
				actualSteamworks.setAchievement(thing);
			}
		}

		public static function setBlocking(block:Boolean):void
		{
			if (block)
			{
				if (actualSteamworks != null)
				{
					actualSteamworks.dispose();
					actualSteamworks = null;
				}
			}
			else
			{
				if (actualSteamworks == null)
				{
					var FRESteamWorks:Class = getDefinitionByName("com.amanitadesign.steam.FRESteamWorks") as Class;
					actualSteamworks = new FRESteamWorks();
					if (actualSteamworks.init())
					{
						actualSteamworks.addOverlayWorkaround(Bezel.Bezel.instance.gameObjects.main, true);
					}
					else
					{
						actualSteamworks = null;
					}
				}
			}
		}
		
	}

}
