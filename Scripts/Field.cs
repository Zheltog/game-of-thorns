using System.Threading.Tasks;
using Godot;

public partial class Field : Node2D
{
	private int _cellsNumHor;
	private int _cellsNumVer;
	private int _cellSize;
	private int _cellsRemaining;
	private Vector2 _center;
	private Cell[,] _cells;
	private PackedScene _scene = GD.Load<PackedScene>("res://cell.tscn");

	public override void _Ready()
	{
	}

	public override void _Process(double delta)
	{
	}

	public void Init(int cellsNumHor, int cellsNumVer)
	{
		_cellsNumHor = cellsNumHor;
		_cellsNumVer = cellsNumVer;
		_cellsRemaining = _cellsNumHor * _cellsNumVer;

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

	public bool HasSalamiLeft()
	{
		return _cellsRemaining > 0;
	}

	public async Task AttackOnSalami(AttackDirection direction)
	{
		switch (direction)
		{
			case AttackDirection.Up:
				await AttackFromDownToUp();
				break;
			case AttackDirection.Down:
				await AttackFromUpToDown();
				break;
			case AttackDirection.Left:
				await AttackFromRifhtToLeft();
				break;
			case AttackDirection.Right:
				await AttackFromLeftToRight();
				break;
		}
	}

	private async Task RemoveThornAndPause(Cell cell)
	{
		cell.RemoveThorn();
		await ToSignal(GetTree().CreateTimer(0.1f), "timeout");
	}

	private async Task RemoveAllAndPause(Cell cell)
	{
		cell.RemoveAll();
		_cellsRemaining--;
		await ToSignal(GetTree().CreateTimer(0.0f), "timeout");
		GD.Print(_cellsRemaining + " cells remaining");
	}

	private async Task<bool> ProcessAndReturnWasThorned(int x, int y)
	{
		Cell cell = _cells[x, y];
		Cell.Status status = cell.CurrentStatus;
		if (status == Cell.Status.Thorned)
		{
			await RemoveThornAndPause(cell);
			return true;
		}
		else if (status == Cell.Status.Salami)
		{
			await RemoveAllAndPause(cell);
		}
		return false;
	}

	private async Task AttackFromUpToDown()
	{
		for (int x = 0; x < _cellsNumHor; x++)
		{
			for (int y = 0; y < _cellsNumVer; y++)
			{
				if (await ProcessAndReturnWasThorned(x, y))
				{
					break;
				}
			}
		}
	}

	private async Task AttackFromDownToUp()
	{
		for (int x = 0; x < _cellsNumHor; x++)
		{
			for (int y = _cellsNumVer - 1; y >= 0; y--)
			{
				if (await ProcessAndReturnWasThorned(x, y))
				{
					break;
				}
			}
		}
	}

	private async Task AttackFromLeftToRight()
	{
		for (int y = 0; y < _cellsNumVer; y++)
		{
			for (int x = 0; x < _cellsNumHor; x++)
			{
				if (await ProcessAndReturnWasThorned(x, y))
				{
					break;
				}
			}
		}
	}

	private async Task AttackFromRifhtToLeft()
	{
		for (int y = 0; y < _cellsNumHor; y++)
		{
			for (int x = _cellsNumHor - 1; x >= 0; x--)
			{
				if (await ProcessAndReturnWasThorned(x, y))
				{
					break;
				}
			}
		}
	}

	public enum AttackDirection
	{
		Up, Down, Left, Right
	}
}
