extends TileMap

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
    pass

func _process(_delta):
    var cells = []
    for i in range(20):
        for j in range(20):
            if rng.randf() > 0.5:
                cells.push_back(Vector2i(i,j))

    clear()
    set_cells_terrain_connect(0, cells, 0, 0)


