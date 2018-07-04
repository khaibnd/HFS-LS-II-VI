/* Hybrid Flowshops with Lot Steaming Model
   Author: Duy Khai
   Creation Date: 03.07.2018
   Revised Date: 04.07.18

/*****************************Parameters**************************************/

{string} operation = ...; // stages indexed by i or l 
tuple Toperation
{
	int	NoMachines;  //  machines indexed by m or k 
	float Setup; // setup time
}
Toperation operationCriteria[operation]= ...; //  
int maxmachines = max(i in operation) operationCriteria[i].NoMachines;

{string} part = ...; // job indexed by n or p 
tuple Tpart
{
	int Demand; // Batch size
	int Lotsize;
	int Maxsublots;
}
Tpart partCriteria[part] = ...;

int maxsublots = max(n in part) partCriteria[n].Maxsublots;

float runtime[part, operation] = ...;

int productionRun[1..maxmachines, operation] = ...;
int maxruns = max(m in 1..maxmachines, i in operation) productionRun[m, i];

int BigM = 1000000;

/*****************************Variables ***********************************/

dvar float+ jobC[j in 1..maxsublots,n in part, i in operation];
dvar float+ runC[r in 1..maxruns,m in 1..maxmachines,i in operation];
dvar int sublotSize[j in 1..maxsublots,n in part];
dvar float Cmax;

dvar boolean x[r in 1..maxruns,m in 1..maxmachines,i in operation, j in 1..maxsublots,n in part];
dvar boolean y[r in 1..maxruns,m in 1..maxmachines,i in operation,n in part];
dvar boolean z[r in 1..maxruns,m in 1..maxmachines,i in operation];
dvar boolean freesublot[j in 1..maxsublots,n in part];

/*****************************Objective ***********************************/

minimize Cmax;


/*****************************Constraints**********************************/


subject to
{
ct1CompletionTime:
	forall(i in operation, n in part, m in 1..operationCriteria[i].NoMachines, j in 1..partCriteria[n].Maxsublots, r in 1..productionRun[operationCriteria[i].NoMachines, i])
	  {
	  		runC[r, m, i] >= jobC[j, n, i] + BigM * x[r, m, i, j, n] - BigM;
	  		runC[r, m, i] <= jobC[j, n, i] - BigM * x[r, m, i, j, n] + BigM; 	  	  
	  }
/*
ct2StartingAfterFinishingPriorRun:
	forall()
	  {
	  	  
	  }


ct3SetupTimeForNewPartOnMachine:
	forall()
	  {
	  
	  
	  	  
	  }

ct4BinaryConstraints:
	forall()
	  {
	  	y	  
	  }
	forall()
	  {
	  	z  
	  }
	forall()
	  {
	  	sublotSize	  
	  }
	  
	forall()
	  {
	  	freesublot	  
	  }

ct5MachineAssignment:
	forall()
	  {
	  	  
	  }

ct6DemandSactisfaction:
	forall()
	  {
	  	  
	  }

ct7SublotAssignment:
	forall()
	  {
	  	  
	  }

ct8CmaxConstraint:
	Cmax == sum()
*/
}

/*****************************Constraints**********************************/
