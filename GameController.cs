using Godot;

public partial class GameController : Node2D
{
	[Export]
	private int _cellsNumHor;

	[Export]
	private int _cellsNumVer;

	[Export]
	private int _cellSize;

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
		for (int x = 0; x < _cellsNumHor; x++)
		{
			for (int y = 0; y < _cellsNumVer; y++)
			{
				Cell cell = _scene.Instantiate<Cell>();
				cell.Name = "Cell[" + x + "," + y + "]";
				AddChild(cell);
				cell.Position = new Vector2(x * _cellSize, y * _cellSize);
			}
		}
	}
}
