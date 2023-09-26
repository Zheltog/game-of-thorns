using Godot;

public static class GameControllerProxy
{
    private static GameController _controller;

	public static void Init(GameController controller)
    {
        _controller = controller;
    }

	public static bool CanTakeThorn()
	{
		return _controller.CanTakeThorn();
	}

	public static void TakeThorn()
	{
		_controller.TakeThorn();
	}
}
