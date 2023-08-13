extends TileMap

const BlobTiling = preload("res://BlobTiling.gd")

var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var use_blob_tiling : bool = false

func _ready():
    pass

func _process(_delta):
    var cells = []
    for i in range(20):
        for j in range(20):
            if rng.randf() > 0.5:
                cells.push_back(Vector2i(i,j))

    clear()
    if (use_blob_tiling):
        set_cells_blob_tiling(0, cells, 0, 0)
    else:
        set_cells_terrain_connect(0, cells, 0, 0)


func set_cells_blob_tiling(
    layer : int,
    cells : Array,
    terrain_set : int,
    terrain : int,
    ignore_empty_terrains : bool = true
):
    var cell_to_tilemap_pos = BlobTiling.blob_tile(cells)
    for cell in cell_to_tilemap_pos:
        var tilemap_pos = cell_to_tilemap_pos[cell]
        set_cell(layer, cell, terrain, tilemap_pos)

func _on_check_button_toggled(button_pressed:bool):
    use_blob_tiling = button_pressed