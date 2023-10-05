using Godot;

public partial class Cell : Node2D
{
	public Status CurrentStatus { get; private set; } = Status.Salami;

	private Sprite2D _base;
	private Sprite2D _salami;
	private Sprite2D _thorn;

	private float _initialSizeX;
	private float _initialSizeY;

	public override void _Ready()
	{
		_base = GetNode<Sprite2D>("Base");
		_salami = GetNode<Sprite2D>("Salami");
		_thorn = GetNode<Sprite2D>("Thorn");

		_initialSizeX = _base.Texture.GetSize().X;
		_initialSizeY = _base.Texture.GetSize().Y;
	}

	public override void _Process(double delta)
	{
	}

	public void SetSize(float sizeX, float sizeY)
	{
		Vector2 scale = new(sizeX / _initialSizeX, sizeY / _initialSizeY);
		Scale = scale;
	}

	public void RemoveAll()
	{
		CurrentStatus = Status.Empty;
		_base.Modulate = new Color(1, 1, 1, 0.5f);
		_salami.Modulate = new Color(1, 1, 1, 0);
		_thorn.Modulate = new Color(1, 1, 1, 0);
	}

	public void RemoveThorn()
	{
		CurrentStatus = Status.Salami;
		_base.Modulate = new Color(1, 1, 1, 1);
		_salami.Modulate = new Color(1, 1, 1, 1);
		_thorn.Modulate = new Color(1, 1, 1, 0);
	}
	
	public void OnButtonPressed()
	{
		TrySetThorn();
	}

	private void TrySetThorn()
	{
		if (GameControllerProxy.CanTakeThorn() && CurrentStatus == Status.Salami)
		{
			GameControllerProxy.TakeThorn();
			SetThorn();
		}
	}

	private void SetThorn()
	{
		CurrentStatus = Status.Thorned;
		_base.Modulate = new Color(1, 1, 1, 1);
		_salami.Modulate = new Color(1, 1, 1, 0.5f);
		_thorn.Modulate = new Color(1, 1, 1, 1);
	}

	public enum Status
	{
		Salami, Thorned, Empty
	}
}
