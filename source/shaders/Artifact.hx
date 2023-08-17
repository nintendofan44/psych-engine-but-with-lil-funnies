package shaders;

import openfl.Lib;
import openfl.utils.Assets;
import flixel.system.FlxAssets.FlxShader;

class Artifact
{
	public var shader:ArtifactShader = new ArtifactShader();
    public var shader2:ArtifactShader2 = new ArtifactShader2();

	public function new()
	{
		shader.iTime.value = [0];
        shader2.iTime.value = [0];
        shader2.iTimeDelta.value = [0];
	}

	public function update(elapsed:Float, delta:Float)
	{
		shader.iTime.value[0] += elapsed;
        shader2.iTime.value[0] += elapsed;
        shader2.iTimeDelta.value[0] = delta;
	}
}

/**
 * Author: https://www.shadertoy.com/user/kusma
 * 
 * Fnf porter/adapter for this shader: nintendofan44
 */
class ArtifactShader extends FlxShader
{
	@:glFragmentSource('
        #pragma header

        uniform float iTime; // shader playback time (in seconds)
        
        float rand(vec2 co) {
            return fract(asin(tanh(tan(cos(sin(dot(co.xy ,vec2(12.9898,78.233))))))) * 437586.5453) * 2.0 * 1.0;
        }
        
        float offset(float blocks, vec2 uv) {
            return rand(vec2(iTime, floor(acos(asin(uv.yx) * 0.6) * blocks)));
        }
        
        void main(void)
        {
            vec2 uv = openfl_TextureCoordv;
            
            gl_FragColor = texture(bitmap, uv);
            gl_FragColor.r = texture(bitmap, uv + vec2(offset(61111.0, uv) * 0.03, 0.01)).r;	
            gl_FragColor.g = texture(bitmap, uv + vec2(offset(61111.0, uv) * 0.03 * 0.16666666, 0.0)).g;
            gl_FragColor.b = texture(bitmap, uv + vec2(offset(61111.0, uv) * 0.03, 0.01)).b;
        }
    ')
	public function new()
	{
		super();
	}
}

class ArtifactShader2 extends FlxShader
{
	@:glFragmentSource('
        #pragma header

        uniform float iTime; // shader playback time (in seconds)
        uniform float iTimeDelta; // render time (in seconds)
        
        float sat( float t ) {
            return clamp( t, 0.0, 1.0 );
        }
        
        vec2 sat( vec2 t ) {
            return clamp( t, 0.0, 1.0 );
        }

        float remap  ( float t, float a, float b ) {
            return sat( (t - a) / (b - a) );
        }

        float linterp( float t ) {
            return sat( 1.0 - abs( 2.0*t - 1.0 ) );
        }
        
        vec3 spectrum_offset( float t ) {
            vec3 ret;
            float lo = step(t,0.5);
            float hi = 1.0-lo;
            float w = linterp( remap( t, 1.0/6.0, 5.0/6.0 ) );
            float neg_w = 1.0-w;
            ret = vec3(lo,1.0,hi) * vec3(neg_w, w, neg_w);
            return pow( ret, vec3(1.0/2.2) );
        }

        float rand( vec2 n ) {
          return fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453);
        }

        float srand( vec2 n ) {
            return rand(n) * 2.0 - 1.0;
        }
        
        float mytrunc( float x, float num_levels )
        {
            return floor(x*num_levels) / num_levels;
        }

        vec2 mytrunc( vec2 x, float num_levels )
        {
            return floor(x*num_levels) / num_levels;
        }
        
        void main(void)
        {
            vec2 uv = openfl_TextureCoordv;
            uv.y = uv.y;
            
            float time = mod(iTime*100.0, 32.0)/110.0; // + modelmat[0].x + modelmat[0].z;
        
            float GLITCH = 0.1 + (sin(-0.000001) - iTime * (iTimeDelta * (iTimeDelta * 1.01))) / 1.0;
            
            float gnm = cosh(trunc(GLITCH));
            float rnd0 = rand( mytrunc( vec2(time, time), 6.0 ) );
            float r0 = sat((1.0-gnm)*0.7 + rnd0);
            float rnd1 = rand( vec2(mytrunc( uv.x, 10.0*r0 ), time) ); //horz
            //float r1 = 1.0f - sat( (1.0f-gnm)*0.5f + rnd1 );
            float r1 = 0.5 - 0.5 * gnm + rnd1;
            r1 = 1.0 - max( 0.0, ((r1<1.0) ? r1 : 0.9999999) ); //note: weird ass bug on old drivers
            float rnd2 = rand( vec2(mytrunc( uv.y, 40.0*r1 ), time) ); //vert
            float r2 = sat( rnd2 );
        
            float rnd3 = rand( vec2(mytrunc( uv.y, 10.0*r0 ), time) );
            float r3 = (1.0-sat(rnd3+0.8)) - 0.1;
        
            float pxrnd = rand( uv + time );
        
            float ofs = 0.05 * r2 * GLITCH * ( rnd0 > 0.5 ? 1.0 : -1.0 );
            ofs += 0.5 * pxrnd * ofs;
        
            uv.y += 0.1 * r3 * GLITCH;
        
            const int NUM_SAMPLES = 20;
            const float RCP_NUM_SAMPLES_F = 1.0 / float(NUM_SAMPLES);
            
            vec4 sum = vec4(0.0);
            vec3 wsum = vec3(0.0);
            for( int i=0; i<NUM_SAMPLES; ++i )
            {
                float t = float(i) * RCP_NUM_SAMPLES_F;
                uv.x = sat( uv.x + ofs * t );
                vec4 samplecol = texture( bitmap, uv, -10.0 );
                vec3 s = spectrum_offset( t );
                samplecol.rgb = samplecol.rgb * s;
                sum += samplecol;
                wsum += s;
            }
            sum.rgb /= wsum;
            sum.a *= RCP_NUM_SAMPLES_F;
        
            gl_FragColor.a = sum.a;
            gl_FragColor.rgb = sum.rgb; // * outcol0.a;
        }        
    ')
	public function new()
	{
		super();
	}
}
