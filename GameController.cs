using System.Threading;
using Godot;

public partial class GameController : Node2D
{
	[Export]
	private int _initialThornsNum;

	private int _currentThornsNum;

	private int _roundNumber;

	private Field _field;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		GD.Print(GetViewportRect().Size.X);

		GameControllerProxy.Init(this);
		_field = GetNode<Field>("Field");
		_currentThornsNum = _initialThornsNum;
		_roundNumber = 0;

		StartNewRound();
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
			FinishRound();
		}
	}

	private async void FinishRound()
	{
		await _field.RemoveUnprotectedCells();
		await _field.SetThornedCellsDefault();
		StartNewRound();
	}

	private void StartNewRound()
	{
		_roundNumber++;
		_currentThornsNum = _initialThornsNum - _roundNumber + 1;
		GD.Print("Round #" + _roundNumber);
		GD.Print("You got " + _currentThornsNum + " thorns");
	}
}
