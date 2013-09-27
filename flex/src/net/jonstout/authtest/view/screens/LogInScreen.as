package net.jonstout.authtest.view.screens
{
	import feathers.controls.Button;
	import feathers.controls.TextInput;
	
	import net.jonstout.authtest.core.Notification;
	import net.jonstout.authtest.data.Credentials;
	import net.jonstout.authtest.data.ScreenId;
	
	import starling.events.Event;

	public class LogInScreen extends BaseScreen
	{
		private var emailInput:TextInput;
		private var passInput:TextInput;
		private var submitBtn:Button;
		private static const GAP:int = 40;
		
		public function LogInScreen()
		{
			super();
			this.title = "AuthTest > Log In";
			this.isBackButtonShown = true;
		}
		
		override protected function initialize():void {
			super.initialize();
			if (!emailInput) {
				emailInput = new TextInput();
				emailInput.prompt = "Email address";
				addChild(emailInput);
				
				passInput = new TextInput();
				passInput.prompt = "Password";
				passInput.displayAsPassword = true;
				addChild(passInput);
				
				submitBtn = new Button();
				submitBtn.addEventListener(Event.TRIGGERED, onSubmit);
				submitBtn.label = "Submit";
				addChild(submitBtn);
			}
		}
		
		override protected function draw():void {
			super.draw();
			if (emailInput) {
				emailInput.width = contentWidth;
				emailInput.x = MARGIN_LEFT;
				emailInput.y = contentY+20;
				emailInput.validate();
				
				passInput.width = contentWidth;
				passInput.x = MARGIN_LEFT;
				passInput.y = emailInput.y + emailInput.height + GAP;
				passInput.validate();
								
				submitBtn.width = contentWidth*0.81;
				submitBtn.x = (contentWidth*0.19*0.5)+MARGIN_LEFT;
				submitBtn.y = contentHeight - submitBtn.height;
				submitBtn.validate();
			}
		}
		
		override public function dispose():void {
			super.dispose();
			emailInput = null;
			passInput = null;
			submitBtn.removeEventListener(Event.TRIGGERED, onSubmit);
			submitBtn = null;
		}
		
		public function onLoggedIn():void {
			hideLoadingMessage();
			navigateTo(ScreenId.START);
			clearForm();
		}
		
		public function onBadCredentials():void {
			hideLoadingMessage();
			alert("Invalid email address or password. Please recheck and try again.");
		}
		
		public function onLogInError(error:String):void {
			hideLoadingMessage();
			if (error != null) {
				alert(error);
			} else {
				alert("Login failed. There was an unknown error.");
			}
		}
		
		private function onSubmit(event:Event):void {
			if ( validateInput() ) {
				var email:String = emailInput.text;
				var pass:String = passInput.text;
				message("Logging in...", true);
				notify(Notification.LOG_IN, { screen:this, credentials:new Credentials(email, pass) });
			}
		}
		
		override protected function onBack():void {
			navigateTo(ScreenId.START);
			clearForm();
		}
		
		private function validateInput():Boolean {
			if (emailInput.text.length == 0) {
				alert("Please input an email address.");
				return false;
			}
			if (passInput.text == null || passInput.text.length < 6) {
				alert("Please input a password at least 6 characters long.");
				return false;
			}
			return true;
		}
		
		private function clearForm():void {
			passInput.text = "";
		}
	}
}