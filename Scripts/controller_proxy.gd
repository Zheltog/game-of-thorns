class_name GameControllerProxy

static var _controller: GameController

static func init(controller: GameController):
	_controller = controller
	
static func can_take_thorn():
	return _controller.can_take_thorn()

static func take_thorn():
	return _controller.take_thorn()
