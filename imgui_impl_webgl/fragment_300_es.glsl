#version 300 es

precision mediump float;

uniform sampler2D Texture;

in vec2 Frag_UV;
in vec4 Frag_Color;

layout (location = 0) out vec4 Out_Color;

void main()
{
	Out_Color = Frag_Color * texture(Texture, Frag_UV.st);
}

