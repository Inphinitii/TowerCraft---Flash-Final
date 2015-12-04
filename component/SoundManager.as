package component
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.media.SoundChannel;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.media.SoundTransform;
	
	public class SoundManager 
	{
		var scMusic:SoundChannel;
		var scSound:SoundChannel;
		var currVolume:SoundTransform;
		
		
		var titleMusic:Sound = new Sound(new URLRequest("audio/titleMusic.mp3"));
		var gameMusic:Sound = new Sound(new URLRequest("audio/gameMusic.mp3"));
		var arrowFired:Sound = new Sound(new URLRequest("audio/arrowFired.mp3"));
		var arrowHit:Sound = new Sound(new URLRequest("audio/arrowHit.mp3"));
		var fireArrowFired:Sound = new Sound(new URLRequest("audio/fireArrowFired.mp3"));
		var fireArrowHit:Sound = new Sound(new URLRequest("audio/fireArrowHit.mp3"));
		var cannonFired:Sound = new Sound(new URLRequest("audio/cannonFired.mp3"));
		var cannonHit:Sound = new Sound(new URLRequest("audio/cannonHit.mp3"));
		var placeItem:Sound = new Sound(new URLRequest("audio/placeItem.mp3"));


		public function SoundManager() 
		{
			scMusic = new SoundChannel();
			scSound = new SoundChannel();
			currVolume = new SoundTransform();
		}
		
		public function playTitleMusic():void
		{
			scMusic = titleMusic.play();
			currVolume.volume = 0.50;
			scMusic.soundTransform = currVolume;
		}
		public function stopTitleMusic():void
		{
			scMusic.stop();
		}
		
		public function playGameMusic():void
		{
			scMusic = gameMusic.play();
			currVolume.volume = 0.25;
			scMusic.soundTransform = currVolume;
		}
		public function stopGameMusic():void
		{
			scMusic.stop();
		}
		
		public function playArrowFired():void
		{
			scSound = arrowFired.play()
			currVolume.volume = 0.50;
			scSound.soundTransform = currVolume;
		}

		public function playArrowHit():void
		{
			scSound = arrowHit.play()
		}
		
		public function playFireArrowFired():void
		{
			scSound = fireArrowFired.play()
		}
		
		public function playFireArrowHit():void
		{
			scSound = fireArrowHit.play()
		}
		
		public function playCannonFired():void
		{
			scSound = cannonFired.play()
		}
		
		public function playCannonHit():void
		{
			scSound = cannonHit.play()
		}
		
		public function playPlaceItem():void
		{
			scSound = placeItem.play()
		}
	}
	
}
