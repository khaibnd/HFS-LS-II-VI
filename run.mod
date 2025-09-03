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

dvar boolean B[n in part,i in operation];



/*****************************Objective ***********************************/

minimize Cmax;


/*****************************Constraints**********************************/


subject to
{

/*
ct1CompletionTime:
	forall(i in operation, n in part, m in 1..operationCriteria[i].NoMachines, j in 1..partCriteria[n].Maxsublots, r in 1..productionRun[operationCriteria[i].NoMachines, i])
	  {
	  		runC[r, m, i] >= jobC[j, n, i] - BigM *( 1 - x[r, m, i, j, n]);
	  		runC[r, m, i] <= jobC[j, n, i] + BigM *( 1 + x[r, m, i, j, n]); 	  	  
	  }
*/
ct2StartingAfterFinishingPriorRun:
	forall(i in operation, n in part, m in 1..operationCriteria[i].NoMachines, j in 1..partCriteria[n].Maxsublots, r in 1..productionRun[operationCriteria[i].NoMachines, i] : r > 1 && runtime[i, n] > 0)
	  {
	  	  runC[r, m, i] - runtime[i, n] * sublotSize[j, n] - operationCriteria[i].Setup - BigM * (y[r-1, m,i ,n] + x[r, m, i, j, n] - 2) >= runC[r-1, m, i];
	  }

/*
ct3SetupTimeForNewPartOnMachine:
	forall()
	  {
	  
	  
	  	  
	  }
*/
ct4BinaryConstraints:
	forall(i in operation, n in part, m in 1..operationCriteria[i].NoMachines, r in 1..productionRun[operationCriteria[i].NoMachines, i])
	  {
	  	y[r, m,i ,n] == sum(j in 1..partCriteria[n].Maxsublots) x[r, m, i, j, n];
	  }
	forall(i in operation, m in 1..operationCriteria[i].NoMachines, r in 1..productionRun[operationCriteria[i].NoMachines, i])
	  {
	  	z[r, m, i]  == sum(n in part, j in 1..partCriteria[n].Maxsublots) x[r, m, i, j, n];
	  }
	forall(n in part, j in 1..partCriteria[n].Maxsublots)
	  {
	  	sublotSize[j, n] <= BigM * freesublot[j, n];
	  }
	  
	forall(n in part, j in 1..partCriteria[n].Maxsublots)
	  {
	  	freesublot[j, n] <= sublotSize[j, n];
	  }

ct5MachineAssignment:
	forall(i in operation, m in 1..operationCriteria[i].NoMachines, r in 1..productionRun[operationCriteria[i].NoMachines, i])
	  {
	  	  z[r + 1, m, i] == z[r, m, i];
	  }

ct6DemandSactisfaction:
	forall(n in part)
	  {
	  	 sum(j in 1..partCriteria[n].Maxsublots) sublotSize[j, n] == partCriteria[n].Demand;
	  }

ct7SublotAssignment:
	forall(i in operation, n in part,j in 1..partCriteria[n].Maxsublots)
	  {
	  	  sum(m in 1..operationCriteria[i].NoMachines, r in 1..productionRun[operationCriteria[i].NoMachines, i]) x[r, m, i, j, n] == freesublot[j, n] * B[n, i];
	  }

ct7aBdetermination:
	forall(i in operation, n in part)
	  {
	  	if 	  
	  }

ct8CmaxConstraint:
	Cmax == sum(r in 1..maxruns,m in 1..maxmachines,i in operation) runC[r, m, i];

}

/*****************************Constraints**********************************/
