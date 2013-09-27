package net.jonstout.authtest.view.screens
{
	import feathers.controls.Button;
	import feathers.controls.TextInput;
	
	import net.jonstout.authtest.core.Notification;
	import net.jonstout.authtest.data.Credentials;
	import net.jonstout.authtest.data.ScreenId;
	
	import starling.events.Event;

	public class RegisterScreen extends BaseScreen
	{
		private var emailInput:TextInput;
		private var passInput:TextInput;
		private var confirmPassInput:TextInput;
		private var submitBtn:Button;
		private static const GAP:int = 40;
		
		public function RegisterScreen()
		{
			super();
			this.title = "AuthTest > Register";
			isBackButtonShown = true;
		}
		
		override protected function initialize():void {
			super.initialize();
			if (!emailInput) {
				emailInput = new TextInput();
				emailInput.prompt = "Email address";
				emailInput.nextTabFocus = passInput;
				addChild(emailInput);
				
				passInput = new TextInput();
				passInput.prompt = "Password";
				passInput.displayAsPassword = true;
				passInput.nextTabFocus = confirmPassInput;
				addChild(passInput);
				
				confirmPassInput = new TextInput();
				confirmPassInput.prompt = "Confirm password";
				confirmPassInput.displayAsPassword = true;
				confirmPassInput.nextTabFocus = submitBtn;
				addChild(confirmPassInput);
				
				submitBtn = new Button();
				submitBtn.addEventListener(Event.TRIGGERED, onSubmit);
				submitBtn.label = "Submit";
				addChild(submitBtn);
				submitBtn.validate();
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
				
				confirmPassInput.width = contentWidth;
				confirmPassInput.x = MARGIN_LEFT;
				confirmPassInput.y = passInput.y + passInput.height + GAP;
				confirmPassInput.validate();
				
				submitBtn.width = contentWidth*0.81;
				submitBtn.x = (contentWidth*0.19*0.5)+MARGIN_LEFT;
				submitBtn.y = contentHeight - submitBtn.height;
				submitBtn.validate();
			}
		}
		
		override public function dispose():void {
			emailInput = null;
			passInput = null;
			confirmPassInput = null;
			submitBtn.removeEventListener(Event.TRIGGERED, onSubmit);
			submitBtn = null;
		}
		
		override protected function onBack():void {
			navigateTo(ScreenId.START);
			clearForm();
		}
		
		private function onSubmit(event:Event):void {
			if ( validateInput() ) {
				var email:String = emailInput.text;
				var pass:String = passInput.text;
				message("Setting up new account...", true);
				notify(Notification.REGISTER, { screen:this, credentials:new Credentials(email, pass) });
			}
		}
		
		public function onRegistrationComplete():void {
			hideLoadingMessage();
			navigateTo(ScreenId.START);
			clearForm();
		}
		
		public function onAlreadyRegistered():void {
			hideLoadingMessage();
			alert("This device appears to already be registered! Why not try logging in instead?");
		}
		
		public function onRegistrationFailed(errorMessage:String=null):void {
			hideLoadingMessage();
			if (errorMessage != null) {
				alert(errorMessage);
			} else {
				alert("Registration failed. There was an unknown error.");
			}
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
			if (passInput.text != confirmPassInput.text) {
				alert("Input in confirm field does not match password. Please try again.");
				return false;
			}
			return true;
		}
		
		private function clearForm():void {
			passInput.text = "";
			confirmPassInput.text = "";
		}
	}
}