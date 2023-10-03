using System.Threading;
using System.Threading.Tasks;
using Godot;

public partial class Field : Node2D
{
	private int _cellsNumHor;
	private int _cellsNumVer;
	private int _cellSize;
	private Vector2 _center;
	private Cell[,] _cells;
	private PackedScene _scene = GD.Load<PackedScene>("res://cell.tscn");

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	public void Init(int cellsNumHor, int cellsNumVer)
	{
		_cellsNumHor = cellsNumHor;
		_cellsNumVer = cellsNumVer;

		float screenWidth = GetViewportRect().Size.X;
		float screenHeight = GetViewportRect().Size.Y;

		_center = new(screenWidth / 2, screenHeight / 2);
		_cellSize = (int) screenWidth / (_cellsNumHor + 2);

		InitCells();
	}

	private void InitCells()
	{
		_cells = new Cell[_cellsNumHor, _cellsNumVer];

		float leftTopX = _center.X - (_cellsNumHor * _cellSize / 2);
		float leftTopY = _center.Y - (_cellsNumVer * _cellSize / 2);

		float initPosX = leftTopX + _cellSize / 2;
		float initPosY = leftTopY + _cellSize / 2;

		for (int x = 0; x < _cellsNumHor; x++)
		{
			for (int y = 0; y < _cellsNumVer; y++)
			{
				Cell cell = _scene.Instantiate<Cell>();
				AddChild(cell);
				cell.SetSize(_cellSize, _cellSize);
				cell.Name = "Cell[" + x + "," + y + "]";
				cell.Position = new Vector2(initPosX + x * _cellSize, initPosY + y * _cellSize);
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
				Cell.Status status = _cells[x, y].CurrentStatus;

				if (status == Cell.Status.Thorned)
				{
					break;
				}
				else if (status == Cell.Status.Removed)
				{
					continue;
				}

				_cells[x, y].SetRemoved();
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
				Cell.Status status = _cells[x, y].CurrentStatus;
				
				if (status == Cell.Status.Thorned)
				{
					break;
				}
				else if (status == Cell.Status.Removed)
				{
					continue;
				}

				_cells[x, y].SetRemoved();
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
				Cell.Status status = _cells[x, y].CurrentStatus;
				
				if (status == Cell.Status.Thorned)
				{
					break;
				}
				else if (status == Cell.Status.Removed)
				{
					continue;
				}

				_cells[x, y].SetRemoved();
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
				Cell.Status status = _cells[x, y].CurrentStatus;
				
				if (status == Cell.Status.Thorned)
				{
					break;
				}
				else if (status == Cell.Status.Removed)
				{
					continue;
				}

				_cells[x, y].SetRemoved();
				await ToSignal(GetTree().CreateTimer(0.0f), "timeout");
			}
		}
	}
}
