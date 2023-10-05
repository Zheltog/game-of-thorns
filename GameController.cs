using System.Threading;
using Godot;

public partial class GameController : Node2D
{
	[Export]
	private int _initialThornsNum;

	[Export]
	private int _cellsNumHor;

	[Export]
	private int _cellsNumVer;

	private int _currentThornsNum;

	private int _roundNumber = 0;

	private Field _field;

	private Label _label;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		GameControllerProxy.Init(this);
		_field = GetNode<Field>("Field");
		_label = GetNode<Label>("StatusLabel");
		_currentThornsNum = _initialThornsNum;
		_roundNumber = 0;

		_field.Init(_cellsNumHor, _cellsNumVer);
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
		_label.Text = _currentThornsNum + " thorns remaining";

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
		_currentThornsNum = _initialThornsNum - _roundNumber;

		if (_currentThornsNum == 0)
		{
			_label.Text = "Game over\nNo thorns remaining\nYou reached round " + _roundNumber;
			return;
		}

		if (!_field.AreCallsRemaining())
		{
			_label.Text = "Game over\nNo salami remaining\nYou reached round " + _roundNumber;
			return;
		}

		_roundNumber++;

		_label.Text = "Round #" + _roundNumber +
			"\nYou got " + _currentThornsNum + " thorns";
	}
}
