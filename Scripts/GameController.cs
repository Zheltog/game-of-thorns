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

	private readonly List<Field.AttackDirection> _allDirections = Enum
		.GetValues(typeof(Field.AttackDirection))
		.Cast<Field.AttackDirection>()
		.ToList();

	private Field.AttackDirection _nextDirection;

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
		await _field.AttackOnSalami(_nextDirection);
		NextRound();
	}

	private void SetRandomNextAttackDirection()
	{
		Random random = new();
		int randomIndex = random.Next(0, _allDirections.Count - 1);
		Field.AttackDirection randomDirection = _allDirections[randomIndex];
		_nextDirection = randomDirection;
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
		SetRandomNextAttackDirection();

		if (_roundNumber == 1)
		{
			_label.Text = "Round #1\nProtect salami with your thorns!\nNext attack: " + _nextDirection;
			return;
		}

		_label.Text = "Round #" + _roundNumber +
			"\nYou got " + _currentThornsNum +
			" thorns\nNext attack: " + _nextDirection;
	}
}
