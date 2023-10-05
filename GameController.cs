using System;
using System.Collections.Generic;
using System.Linq;
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

	private Label _label;

	private Field _field;

	private List<Field.AttackDirection> _allDirections = Enum
		.GetValues(typeof(Field.AttackDirection))
		.Cast<Field.AttackDirection>()
		.ToList();

	private int _currentDirection;

	public override void _Ready()
	{
		GameControllerProxy.Init(this);

		_label = GetNode<Label>("StatusLabel");
		_field = GetNode<Field>("Field");

		_field.Init(_cellsNumHor, _cellsNumVer);
		_currentThornsNum = _initialThornsNum;
		_roundNumber = 0;

		NextRound();
	}

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
		await _field.AttackOnSalami(NextDirection());
		NextRound();
	}

	private Field.AttackDirection NextDirection()
	{
		Field.AttackDirection nextDirection = _allDirections[_currentDirection];

		_currentDirection++;

		if (_currentDirection >= _allDirections.Count)
		{
			_currentDirection = 0;
		}

		return nextDirection;
	}

	private void NextRound()
	{
		_currentThornsNum = _initialThornsNum - _roundNumber;

		if (_currentThornsNum == 0)
		{
			_label.Text = "Game over\nNo thorns remaining\nYou reached round " + _roundNumber;
			return;
		}

		if (!_field.HasSalamiLeft())
		{
			_label.Text = "Game over\nNo salami remaining\nYou reached round " + _roundNumber;
			return;
		}

		_roundNumber++;

		_label.Text = "Round #" + _roundNumber +
			"\nYou got " + _currentThornsNum + " thorns";
	}
}
