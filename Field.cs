using System.Threading;
using Godot;

public partial class Field : Node2D
{
	[Export]
	private int _cellsNumHor;

	[Export]
	private int _cellsNumVer;

	[Export]
	private int _cellSize;

	private Cell[,] _cells;

	private PackedScene _scene = GD.Load<PackedScene>("res://cell.tscn");

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		InitCells();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	private void InitCells()
	{
		_cells = new Cell[_cellsNumHor, _cellsNumVer];

		for (int x = 0; x < _cellsNumHor; x++)
		{
			for (int y = 0; y < _cellsNumVer; y++)
			{
				Cell cell = _scene.Instantiate<Cell>();
				AddChild(cell);
				cell.Name = "Cell[" + x + "," + y + "]";
				cell.Position = new Vector2(x * _cellSize, y * _cellSize);
				_cells[x, y] = cell;
			}
		}
	}

	public void RemoveUnprotectedCells()
	{
		RemoveCellsFromUpToDown();
		RemoveCellsFromDownToUp();
		RemoveCellsFromLeftToRight();
		RemoveCellsFromRifhtToLeft();
	}

	private async void RemoveCellsFromUpToDown()
	{
		for (int x = 0; x < _cellsNumHor; x++)
		{
			for (int y = 0; y < _cellsNumVer; y++)
			{
				if (TryRemoveCell(x, y))
				{
					break;
				}
				await ToSignal(GetTree().CreateTimer(0.0f), "timeout");
			}
		}
	}

	private async void RemoveCellsFromDownToUp()
	{
		for (int x = 0; x < _cellsNumHor; x++)
		{
			for (int y = _cellsNumVer - 1; y >= 0; y--)
			{
				if (TryRemoveCell(x, y))
				{
					break;
				}
				await ToSignal(GetTree().CreateTimer(0.0f), "timeout");
			}
		}
	}

	private async void RemoveCellsFromLeftToRight()
	{
		for (int y = 0; y < _cellsNumVer; y++)
		{
			for (int x = 0; x < _cellsNumHor; x++)
			{
				if (TryRemoveCell(x, y))
				{
					break;
				}
				await ToSignal(GetTree().CreateTimer(0.0f), "timeout");
			}
		}
	}

	private async void RemoveCellsFromRifhtToLeft()
	{
		for (int y = 0; y < _cellsNumHor; y++)
		{
			for (int x = _cellsNumHor - 1; x >= 0; x--)
			{
				if (TryRemoveCell(x, y))
				{
					break;
				}
				await ToSignal(GetTree().CreateTimer(0.0f), "timeout");
			}
		}
	}

	private bool TryRemoveCell(int x, int y)
	{
		Cell cell = _cells[x, y];
		if (cell.CurrentStatus == Cell.Status.Default)
		{
			cell.SetRemoved();
			return false;
		}
		return true;
	}
}
