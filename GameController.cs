using Godot;

public partial class GameController : Node2D
{
	[Export]
	private int _initialThornsNum;

	private int _currentThornsNum;

	private Field _field;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		GameControllerProxy.Init(this);
		_field = GetNode<Field>("Field");
		_currentThornsNum = _initialThornsNum;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	public bool CanTakeThorn()
	{
		return _currentThornsNum > 0;
	}

	public void TakeThorn()
	{
		_currentThornsNum--;
		GD.Print(_currentThornsNum + " thorns remaining");

		if (_currentThornsNum == 0)
		{
			_field.RemoveUnprotectedCells();
		}
	}
}
