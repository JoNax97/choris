shader_type spatial;



void fragment() {
  COLOR = ProcessChromaKey(TEXTURE, UV);
}