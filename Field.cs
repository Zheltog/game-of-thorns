using System.Threading;
using System.Threading.Tasks;
using Godot;

public partial class Field : Node2D
{
	[Export]
	private int _cellsNumHor;

	[Export]
	private int _cellsNumVer;

	// TODO
	[Export]
	private int _cellSize = 50;

	private Vector2 _center;

	private Cell[,] _cells;

	private PackedScene _scene = GD.Load<PackedScene>("res://cell.tscn");

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		InitCenter();
		InitCells();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	private void InitCenter()
	{
		float width = GetViewportRect().Size.X;
		float height = GetViewportRect().Size.Y;
		_center = new(width / 2, height / 2);
	}

	private void InitCells()
	{
		_cells = new Cell[_cellsNumHor, _cellsNumVer];
		float leftTopX = _center.X - (_cellsNumHor * _cellSize / 2);
		float leftTopY = _center.Y - (_cellsNumVer * _cellSize / 2);

		GD.Print(leftTopX);
		GD.Print(leftTopY);

		for (int x = 0; x < _cellsNumHor; x++)
		{
			for (int y = 0; y < _cellsNumVer; y++)
			{
				Cell cell = _scene.Instantiate<Cell>();
				AddChild(cell);
				cell.Name = "Cell[" + x + "," + y + "]";
				cell.Position = new Vector2(leftTopX + x * _cellSize, leftTopY + y * _cellSize);
				_cells[x, y] = cell;
			}
		}
	}

	public async Task RemoveUnprotectedCells()
	{
		await RemoveCellsFromUpToDown();
		await RemoveCellsFromDownToUp();
		await RemoveCellsFromLeftToRight();
		await RemoveCellsFromRifhtToLeft();
	}

	public async Task SetThornedCellsDefault()
	{
		for (int x = 0; x < _cellsNumHor; x++)
		{
			for (int y = 0; y < _cellsNumVer; y++)
			{
				Cell cell = _cells[x, y];
				if (cell.CurrentStatus == Cell.Status.Thorned)
				{
					cell.SetDefault();
				}
				await ToSignal(GetTree().CreateTimer(0.0f), "timeout");
			}
		}
	}

	private async Task RemoveCellsFromUpToDown()
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

	private async Task RemoveCellsFromDownToUp()
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

	private async Task RemoveCellsFromLeftToRight()
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

	private async Task RemoveCellsFromRifhtToLeft()
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
		if (cell.CurrentStatus != Cell.Status.Thorned)
		{
			cell.SetRemoved();
			return false;
		}
		return true;
	}
}
