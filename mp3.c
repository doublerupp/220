#include <stdio.h>
#include <stdlib.h>
#include <math.h>


int main()
{
	double omega1, omega2, omegac, T, dt;
	int N;

	//Scan the inputs from the user.
	scanf("%lf %lf %lf", &omega1, &omega2, &omegac);
	
	T = 3 * 2 * M_PI / omega1;      // Total time
    	N = 20 * T / (2 * M_PI / omega2);   // Total number of time steps
    	dt = T / N;             // Time step

	int i; //loop counter
	double Voutnew = 0, Voutcur = 0, Voutprev = 0;

	//Write your code here!
	//for loop to run through the calculation an N number of times
	for(i=0; i<=N; i++)
	{
		//break the discretized code into pieces a, b, and c for simplcity 
		double a = 1/((1/(sqrt(2)*dt*omegac))+(1/(dt*dt*omegac*omegac)));
		double b =((2/(dt*dt*omegac*omegac))-1)*Voutcur;
		double c = (((1/(sqrt(2)*dt*omegac))-(1/(dt*dt*omegac*omegac))))*Voutprev;
		Voutnew= (a)*(((b+c+sin((omega1*i*dt))+(.5*sin((omega2*i*dt))))));

	//print out the current voltage value
	printf("%lf \n", Voutcur); 
	// update voltages before returning to the top of the loop
	Voutprev = Voutcur;
	Voutcur = Voutnew;
	}


	return 0;
}

    
