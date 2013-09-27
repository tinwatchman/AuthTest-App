package net.jonstout.authtest.control
{	
	import feathers.core.PopUpManager;
	
	import net.jonstout.authtest.core.Command;
	import net.jonstout.authtest.core.Notification;
	import net.jonstout.authtest.data.AlertRequest;
	import net.jonstout.authtest.view.alerts.Alert;
	import net.jonstout.authtest.view.alerts.Confirm;
	import net.jonstout.authtest.view.alerts.Message;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	
	public class ShowAlertCommand extends Command
	{
		private var request:AlertRequest;
		private var message:Message;
		private var alert:Alert;
		private var confirm:Confirm;
		private var isPopUpManagerSetUp:Boolean=false;
		
		public function ShowAlertCommand()
		{
			super(Notification.SHOW_ALERT);
		}
		
		override public function execute(data:Object=null):void {
			// set up PopUpManager
			if (!isPopUpManagerSetUp) {
				PopUpManager.overlayFactory = function():DisplayObject {
					var quad:Quad = new Quad(100, 100, 0x000000);
					quad.alpha = 0.5;
					return quad;
				};
				isPopUpManagerSetUp = true;
			}
			
			// down to business
			request = data as AlertRequest;
			if (request != null) {
				switch (request.type) {
					case AlertRequest.MESSAGE:
						showMessage();
						break;
					case AlertRequest.ALERT:
						showAlert();
						break;
					case AlertRequest.CONFIRM:
						showConfirm();
						break;
				}
			}
			//alert = new OldAlert(data);
			//alert.addEventListener(OldAlert.CLOSE, onCloseAlert);
			//PopUpManager.addPopUp(alert, true, true);
		}
		
		// MESSAGE FUNCTIONALITY
		
		private function showMessage():void {
			message = new Message(request.text);
			facade.addEventListener(Notification.HIDE_ALERT, onHideMessage);
			PopUpManager.addPopUp(message, true, true);
		}
		
		private function onHideMessage(event:Notification):void {
			facade.removeEventListener(Notification.HIDE_ALERT, onHideMessage);
			PopUpManager.removePopUp(message, true);
			message = null;
			request.ok();
			clearRequest();
		}
		
		// ALERT FUNCTIONALITY
		
		private function showAlert():void {
			alert = new Alert(request.text, request.okText);
			alert.addEventListener(Alert.OKAY, onCloseAlert);
			facade.addEventListener(Notification.HIDE_ALERT, onHideAlert);
			PopUpManager.addPopUp(alert, true, true);
		}
		
		private function onCloseAlert(event:Event):void {
			closeAlert();
		}
		
		private function onHideAlert(event:Notification):void {
			closeAlert();
		}
		
		private function closeAlert():void {
			facade.removeEventListener(Notification.HIDE_ALERT, onHideAlert);
			alert.removeEventListener(Alert.OKAY, onCloseAlert);
			PopUpManager.removePopUp(alert, true);
			alert = null;
			request.ok();
			clearRequest();
		}
		
		// CONFIRM FUNCTIONALITY
		
		private function showConfirm():void {
			confirm = new Confirm(request.text, request.okText, request.cancelText);
			confirm.addEventListener(Confirm.OKAY, onConfirmClick);
			confirm.addEventListener(Confirm.CANCEL, onCancelClick);
			facade.addEventListener(Notification.HIDE_ALERT, onHideConfirm);
			PopUpManager.addPopUp(confirm, true, true);
		}
		
		private function onConfirmClick(event:Event):void {
			onConfirmed();
		}
		
		private function onCancelClick(event:Event):void {
			onCanceled();
		}
		
		private function onHideConfirm(event:Event):void {
			onCanceled();
		}
		
		private function onConfirmed():void {
			closeConfirm();
			request.ok();
			clearRequest();
		}
		
		private function onCanceled():void {
			closeConfirm();
			request.cancel();
			clearRequest();
		}
		
		private function closeConfirm():void {
			confirm.removeEventListener(Confirm.OKAY, onConfirmClick);
			confirm.removeEventListener(Confirm.CANCEL, onCancelClick);
			facade.removeEventListener(Notification.HIDE_ALERT, onHideConfirm);
			PopUpManager.removePopUp(confirm, true);
			confirm = null;
		}
		
		private function clearRequest():void {
			if (request) {
				request.clear();
				request = null;
			}
		}
	}
}