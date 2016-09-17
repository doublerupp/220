#include <stdio.h>
#include <stdlib.h>
#include <math.h>


int main()
{
	double omega1, omega2, omegac, T, dt;
	int N;

	//Scan the inputs from the user.
	printf("Please enter omega1 omega2 omegac");
	scanf("%lf %lf %lf", &omega1, &omega2, &omegac);
	
	T = 3 * 2 * M_PI / omega1;      // Total time
    	N = 20 * T / (2 * M_PI / omega2);   // Total number of time steps
    	dt = T / N;             // Time step

	int i;
	double Voutnew = 0, Voutcur = 0, Voutprev = 0;

	//Write your code here!
	for(i=0; i<N; i++)
	{
		double a = 1/((1/(sqrt(2)*dt*omegac))+(1/(dt*dt*omegac*omegac)));
		double b =((2/(dt*dt*omegac*omegac))-1)*Voutcur;
		double c = 1/(sqrt(2)*dt*omegac)-1/(dt*dt*omegac*omegac)*Voutprev;
		Voutnew= a*(b+c+sin(omega1*i*dt)+.5*sin(omega2*i*dt));


	printf("%lf", Voutnew);
	Voutprev = Voutcur;
	Voutcur = Voutnew;
	}


	return 0;
}
