# version 120 

// Mine is an old machine.  For version 130 or higher, do 
// in vec4 color ;  
// in vec4 mynormal ; 
// in vec4 myvertex ;
// That is certainly more modern

varying vec4 color ;
varying vec3 mynormal ; 
varying vec4 myvertex ; 

uniform int islight ; // are we lighting. 

// Assume light 0 and light 1 are both point lights
// The actual light values are passed from the main OpenGL program. 
// This could of course be fancier.  My goal is to illustrate a simple idea. 

uniform vec4 light0posn ; 
uniform vec4 light0color ; 
uniform vec4 light1posn ; 
uniform vec4 light1color ;
uniform vec4 lights[20]; 

// Now, set the material parameters.  These could be varying and/or bound to 
// a buffer.  But for now, I'll just make them uniform.  
// I use ambient, diffuse, specular, shininess as in OpenGL.  
// But, the ambient is just additive and doesn't multiply the lights.  

uniform vec4 ambient ; 
uniform vec4 diffuse ; 
uniform vec4 specular ; 
uniform vec4 emission;
uniform float shininess ; 

vec4 ComputeLight (const in vec3 direction, const in vec4 lightcolor, const in vec3 normal, const in vec3 halfvec, const in vec4 mydiffuse, const in vec4 myspecular, const in float myshininess) {

        float nDotL = dot(normal, direction)  ;         
        vec4 lambert = mydiffuse * lightcolor * max (nDotL, 0.0) ;  

        float nDotH = dot(normal, halfvec) ; 
        vec4 phong = myspecular * lightcolor * pow (max(nDotH, 0.0), myshininess) ; 

        vec4 retval = lambert + phong ; 
        return retval ;            
}       

void main (void) 
{       
    if (islight == 0) gl_FragColor = color ; 
    else { 
        // They eye is always at (0,0,0) looking down -z axis 
        // Also compute current fragment position and direction to eye 

        const vec3 eyepos = vec3(0,0,0) ; 
        vec4 _mypos = gl_ModelViewMatrix * myvertex ; 
        vec3 mypos = _mypos.xyz / _mypos.w ; // Dehomogenize current location 
        vec3 eyedirn = normalize(eyepos - mypos) ; 

        // Compute normal, needed for shading. 
        // Simpler is vec3 normal = normalize(gl_NormalMatrix * mynormal) ; 
        vec3 _normal = (gl_ModelViewMatrixInverseTranspose*vec4(mynormal,0.0)).xyz ; 
        vec3 normal = normalize(_normal) ; 

        // Light 0, point
        //vec3 position0; 
        //vec3 direction0; // no attenuation 
		//if (light0posn.w == 0){
		//	position0 = light0posn.xyz;
		//	direction0 = normalize(light0posn.xyz);
		//}
		//else{
		//	position0 = light0posn.xyz / light0posn.w;
		//	direction0 = normalize (position0 - mypos);
		//}
		//vec4 test = (gl_NormalMatrix * light0posn.xyz);
		//vec3 direction0 = normalize(light0posn.xyz);
        //vec3 half0 = normalize (direction0 + eyedirn) ;  
        //vec4 col0 = ComputeLight(direction0, light0color, normal, half0, diffuse, specular, shininess) ;

        // Light 1, point 
        //vec3 position1 = light1posn.xyz / light1posn.w ; 
        //vec3 direction1 = normalize (position1 - mypos) ; // no attenuation
		//vec3 position1 = lights[0].xyz / lights[0].w;
		//vec3 direction1 = normalize (position1 - mypos) ; // no attenuation
        //vec3 half1 = normalize (direction1 + eyedirn) ;  
        //vec4 col1 = ComputeLight(direction1, lights[1], normal, half1, diffuse, specular, shininess) ;

		//vec3 position2 = lights[2].xyz / lights[2].w;
		//vec3 direction2 = normalize (position2 - mypos) ; // no attenuation
        //vec3 half2 = normalize (direction2 + eyedirn) ;  
        //vec4 col2 = ComputeLight(direction2, lights[3], normal, half1, diffuse, specular, shininess) ;
        
		gl_FragColor = ambient + emission ;
		
		for(int i = 0; i < 20; i = i + 2){
			vec3 positionlight, directionlight;
			if (lights[i].w == 0){
				directionlight = normalize(lights[i].xyz);
			}
			else{
				positionlight = lights[i].xyz / lights[i].w;
				directionlight = normalize (positionlight - mypos) ; // no attenuation
			}
			vec3 halflight = normalize (directionlight + eyedirn) ;  
			vec4 collight = ComputeLight(directionlight, lights[i + 1], normal, halflight, diffuse, specular, shininess) ;
			gl_FragColor = gl_FragColor + collight;
		}

        
        }
}
