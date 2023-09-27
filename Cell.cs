using Godot;

public partial class Cell : Node2D
{
	[Export]
	public Color _defaultColor = new(1, 1, 1);

	[Export]
	public Color _thornedColor = new(0, 0, 1);

	[Export]
	public Color _removedColor = new(1, 0, 0);

	public Status CurrentStatus { get; private set; } = Status.Default;

	private Sprite2D _sprite;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		_sprite = GetNode<Sprite2D>("Sprite2D");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	public void SetRemoved()
	{
		CurrentStatus = Status.Removed;
		_sprite.Modulate = _removedColor;
	}
	public void SetDefault()
	{
		CurrentStatus = Status.Default;
		_sprite.Modulate = _defaultColor;
	}
	
	public void OnButtonPressed()
	{
		GD.Print("Clicked");
		TrySetThorned();
	}

	private void TrySetThorned()
	{
		if (GameControllerProxy.CanTakeThorn())
		{
			GameControllerProxy.TakeThorn();
			SetThorned();
		}
	}

	private void SetThorned()
	{
		CurrentStatus = Status.Thorned;
		_sprite.Modulate = _thornedColor;
	}

	public enum Status
	{
		Default, Thorned, Removed
	}
}
