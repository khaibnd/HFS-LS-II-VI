/* Hybrid Flowshops with Lot Steaming Model
   Author: Duy Khai
   Creation Date: 03.07.2018
   Revised Date: 
*/


/*****************************Parameters**************************************/

{string} operation = ...; // stages indexed by i or l 
tuple Toperation
{
	int	NoMachines;  //  machines indexed by m or k 
	float Setup; // setup time
}
Toperation operationCriteria[operation]= ...; //  

{string} part = ...; // job indexed by n or p 
tuple Tpart
{
	int Demand; // Batch size
	int Lotsize;
	int Maxsublots;
}
Tpart partCriteria[part] = ...;

float runtime[part, operation] = ...;

int sublot[i in part] =  partCriteria[i].Maxsublots;

int BigM = 1000000;

/*****************************Variables ***********************************/

dvar float+ jobC[part, part,operation];
dvar float+ runC[part, part,operation];
dvar int sublotSize[part, part];
dvar float Cmax;

dvar boolean x[r];
dvar boolean y[];
dvar boolean z[];
dvar boolean freesublot[part];



/*****************************Objective ***********************************/

minimize Cmax;


/*****************************Constraints**********************************/


subject to
{
ct1CompletionTime:
	forall(r in )
	  {
	  
	  	  
	  }

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

}

