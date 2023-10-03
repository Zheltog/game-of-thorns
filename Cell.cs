using Godot;

public partial class Cell : Node2D
{
	public Status CurrentStatus { get; private set; } = Status.Default;

	private Sprite2D _base;
	private Sprite2D _salami;
	private Sprite2D _thorn;

	private float _initialSizeX;
	private float _initialSizeY;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		_base = GetNode<Sprite2D>("Base");
		_salami = GetNode<Sprite2D>("Salami");
		_thorn = GetNode<Sprite2D>("Thorn");

		_initialSizeX = _base.Texture.GetSize().X;
		_initialSizeY = _base.Texture.GetSize().Y;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	public void SetSize(float sizeX, float sizeY)
	{
		Vector2 scale = new(sizeX / _initialSizeX, sizeY / _initialSizeY);
		Scale = scale;
	}

	public void SetRemoved()
	{
		CurrentStatus = Status.Removed;
		_base.Modulate = new Color(1, 1, 1, 0.5f);
		_salami.Modulate = new Color(1, 1, 1, 0);
		_thorn.Modulate = new Color(1, 1, 1, 0);
	}

	public void SetDefault()
	{
		CurrentStatus = Status.Default;
		_base.Modulate = new Color(1, 1, 1, 1);
		_salami.Modulate = new Color(1, 1, 1, 1);
		_thorn.Modulate = new Color(1, 1, 1, 0);
	}
	
	public void OnButtonPressed()
	{
		GD.Print("Clicked");
		TrySetThorned();
	}

	private void TrySetThorned()
	{
		if (GameControllerProxy.CanTakeThorn() && CurrentStatus == Status.Default)
		{
			GameControllerProxy.TakeThorn();
			SetThorned();
		}
	}

	private void SetThorned()
	{
		CurrentStatus = Status.Thorned;
		_base.Modulate = new Color(1, 1, 1, 1);
		_salami.Modulate = new Color(1, 1, 1, 0.5f);
		_thorn.Modulate = new Color(1, 1, 1, 1);
	}

	public enum Status
	{
		Default, Thorned, Removed
	}
}
