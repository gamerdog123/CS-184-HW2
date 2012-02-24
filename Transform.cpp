// Transform.cpp: implementation of the Transform class.

// #include "stdafx.h"
#include "Transform.h"

//Takes as input the current eye position, and the current up vector.
//up is always normalized to a length of 1.
//eye has a length indicating the distance from the viewer to the origin

// Helper rotation function.  Please implement this.  

mat3 Transform::rotate(const float degrees, const vec3& axis) {
  mat3 R ; 
  mat3 I(1.0);
  float X = axis.x, Y = axis.y, Z = axis.z, radDegrees = degrees * pi / 180;
  mat3 TempV = mat3(pow(X,2), X * Y, X * Z, X * Y, pow(Y,2), Y * Z, X * Z, Y * Z, pow(Z,2));
  mat3 TempV2 = mat3(0, -Z, Y, Z, 0, -X, -Y, X, 0);
  // FILL IN YOUR CODE HERE
  R = (cos(radDegrees) * I) + ((1 - cos(radDegrees)) * TempV) + (sin(radDegrees) * TempV2);
  return R ; 
}

void Transform::left(float degrees, vec3& eye, vec3& up) {

	//FILL IN YOUR CODE HERE
	mat3 R = Transform::rotate(degrees, glm::normalize(up));
	eye = eye * R;
	//up = glm::normalize(glm::cross(glm::cross(eye,up),eye));
}

void Transform::up(float degrees, vec3& eye, vec3& up) {

	//FILL IN YOUR CODE HERE
	mat3 R = Transform::rotate(degrees, glm::normalize(glm::cross(eye,up)));
	eye = eye * R;
	up = up * R;
	//up = glm::normalize(glm::cross(glm::cross(eye,up * R),eye));
}

mat4 Transform::lookAt(const vec3& eye,const vec3& center,const vec3& up) {
    mat4 M ; 
	//FILL IN YOUR CODE HERE
    //You must return a row-major mat4 M that you create from this routine
	vec3 W = glm::normalize(vec3(eye.x - center.x, eye.y - center.y, eye.z - center.z));
	vec3 U = glm::normalize(glm::cross(up, W));
	vec3 V = glm::cross(W, U);
	vec3 eyeTemp = vec3(-eye[0],-eye[1],-eye[2]);
	M = mat4(U[0],U[1],U[2],glm::dot(U,eyeTemp),V[0],V[1],V[2],glm::dot(V,eyeTemp),W[0],W[1],W[2],glm::dot(W,eyeTemp),0,0,0,1);
	return M ; 
}

mat4 Transform::perspective(float fovy, float aspect, float zNear, float zFar){
	return mat4(1/aspect, 0, 0, 0, 0, 1, 0, 0, 0, 0, -(zFar+zNear)/(zFar-zNear), -(2 * zFar * zNear)/(zFar - zNear), 0, 0, -1, 0);
}

mat4 Transform::scale(const float& sx, const float& sy, const float& sz) {
	return mat4(sx,0,0,0,0,sy,0,0,0,0,sz,0,0,0,0,1);
}

mat4 Transform::translate(const float& tx, const float& ty, const float& tz){
	return mat4(1,0,0,tx,0,1,0,ty,0,0,1,tz,0,0,0,1);
}

Transform::Transform()
{

}

Transform::~Transform()
{

}

// Some notes about using glm functions.
// You are ONLY permitted to use glm::dot glm::cross glm::normalize
// Do not use more advanced glm functions (in particular, directly using 
// glm::lookAt is of course prohibited).  

// You may use overloaded operators for matrix-vector multiplication 
// But BEWARE confusion between opengl (column major) and row major 
// conventions, as well as what glm implements. 
// In particular, vecnew = matrix * vecold may not implement what you think 
// it does.  It treats matrix as column-major, in essence using the transpose.
// We recommend using row-major and vecnew = vecold * matrix 
// Preferrably avoid matrix-matrix multiplication altogether for this hw.  
