#include <stdio.h>

#include <stdlib.h>

#include <math.h>



double abs_double(double y)

{

	if(y<0){return -y;}

    //Change this to return the absolute value of y i.e |y|

	else{

   	 return y;}

}



double fx_val(double a, double b, double c, double d, double e, double x)

{

	y= (a*x*x*x*x) + (b*x*x*x)+ (c*x*x)+ (d*x)+ e;

    //Change this to return the value of the polynomial at the value x

    return y;

}



double fx_dval(double a, double b, double c, double d, double e, double x)

{

	y= (4*a*x*x*x) + (3*b*x*x)+ (2*c*x)+ d;

    //Change this to return the value of the derivative of the polynomial at the value x

    return y;

}



double fx_ddval(double a, double b, double c, double d, double e, double x)

{

	y= (12*a*x*x) + (6*b*x)+ (c);

    //Change this to return the value of the double derivative of the polynomial at the value x

    return y;

}





double newrfind_halley(double a, double b, double c, double d, double e, double x)

{

    //Change this to return the root found starting from the initial point x using Halley's method

    return 0;

}



int rootbound(double a, double b, double c, double d, double e, double r, double l)

{	int Vr,Vl,V;

	if(a*((4*a*l)+b)<0) {Vl++;}

	if(((4*a*l)+b)*((6*a*l*l)+(3*b*l)+c)<0){Vl++;}

	if(((6*a*l*l)+(3*b*l)+c) * ((4*a*l*l*l)+(3*b*l*l)+(2*c*l)+d)<0){Vl++;}

	if(((4*a*l*l*l)+(3*b*l*l)+(2*c*l)+d) * ((a*l*l*l*l)+ (b*l*l*l)+ (c*l*l)+ (d*l) +e)<0){Vl++;}

	if(a*((4*a*r)+b)<0) {Vr++;}

	if(((4*a*r)+b)*((6*a*r*r)+(3*b*r)+c)<0){Vr++;}

	if(((6*a*r*r)+(3*b*r)+c) * ((4*a*r*r*r)+(3*b*r*r)+(2*c*r)+d)<0){Vr++;}

	if(((4*a*r*r*r)+(3*b*r*r)+(2*c*r)+d) * ((a*r*r*r*r)+ (b*r*r*r)+ (c*r*r)+ (d*r) +e)<0){Vr++;}

    //Change this to return the upper bound on the number of roots of the polynomial in the interval (l, r)1

	V=Vl-Vr;

	abs_double(V);

    return V;

}



int main(int argc, char **argv)

{

	double a, b, c, d, e, l, r;

	FILE *in;



	if (argv[1] == NULL) {

		printf("You need an input file.\n");

		return -1;

	}

	in = fopen(argv[1], "r");

	if (in == NULL)

		return -1;

	fscanf(in, "%lf", &a);

	fscanf(in, "%lf", &b);

	fscanf(in, "%lf", &c);

	fscanf(in, "%lf", &d);

	fscanf(in, "%lf", &e);

	fscanf(in, "%lf", &l);

	fscanf(in, "%lf", &r);

    

    //The values are read into the variable a, b, c, d, e, l and r.

    //You have to find the bound on the number of roots using rootbound function.

    //If it is > 0 try to find the roots using newrfind function.

    //You may use the fval, fdval and fddval funtions accordingly in implementing the halleys's method.

    

    

    fclose(in);

    

    return 0;

}
