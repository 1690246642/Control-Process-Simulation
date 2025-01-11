# Control-Process-Simulation
Simulation of an nC4/nC5 distillation column using MATLAB, focusing on stabilizing a non-ideal system with tuned controllers. Includes full code (some parts need improvement) and a PDF detailing goals, challenges, and comparisons to William Luyben's Simulink model. Updates planned for future versions

# Introduction
Distillation is a common separation technique for liquid streams 
containing several components and is one of the most important unit 
operations in chemical manufacturing processes. Distillation is 
designed and controlled to produce a product stream of the required 
purity, whether for sale or for use in other chemical processes. 
Distillation is based on the separation of the components of a liquid 
mixture by the difference in their boiling points. The pure component 
that boils at a lower temperature is the light component and the pure 
component that boils at a higher temperature is the heavy component.
For example, in a mixture of benzene and toluene, benzene is the light 
component and toluene is the heavy component. A saturated liquid 
mixture of the two components at a certain concentration is in 
equilibrium with the vapor phase where the concentration of the light 
component is highest relative to the liquid phase. Let x be the mole 
fraction of the light component in the liquid phase and y be the mole 
fraction of the light component in the vapor phase. For ideal mixtures, 
the phase equilibrium relationship is modeled based on relative 
Evapotranspiration by the following equation:
𝑦 =
𝛼𝑥
1 + (𝛼 − 1)𝑥
where alpha represents the relative volatility. If we consider a 
conceptual design of the operation of a two-component distillation 
tower, the feed usually enters near the middle of the tower. The 
vapor flows from one stage to the next from the bottom up in the 
tower, while the liquid flows from one stage to the next from the top 
down in the tower. The vapor is condensed in the top tray and a portion 
of that liquid is refluxed back into the tower. The remaining liquid is 
removed as the product stream. The liquid leaving the bottom of the 
tower, which contains components with lower relative volatility, is also 
considered the bottom product of the tower, and the remaining liquid 
stream is vaporized through a reboiler and re-enters the tower. The 
liquid passing through each initial tray overflows and flows through a 
chute to the next tray. When the liquid moves in the cylinder, it comes 
into direct contact with the vapor passing through the holes of the 
cylinder and mass transfer occurs between the two phases. Do your 
nomenclature in such a way that the mole fraction of liquid and vapor 
leaving the first cylinder are considered as 𝑥𝑖 and 𝑦𝑖, respectively. 
Also, represent the molar flow rate of liquid and vapor leaving the 
same cylinder as 𝐿𝑖 and 𝑉𝑖 in the equations, respectively. Since the 
liquid entering this cylinder comes from the previous cylinder (the 
naming of the cylinders of the tower is considered from top to 
bottom), use 𝑥𝑖−1 and 𝐿𝑖−1 for the liquid mole fraction and its molar 
flow rate, respectively. Using a similar argument, this time for the 
next cylinder, which is the source of the vapor to the current cylinder, 
use 𝑦𝑖+1 and 𝑉𝑖+1 for its molar fraction and molar flow rate, 
respectively. Now, let's proceed to modeling the normal butane and 
normal pentane distillation towers. First, you should review the 
problem specification and the governing assumptions and equations. A 
butanizer column is considered as a sample. A mixture of 50 mol% nbutane (4nC) and 50 mol% n-pentane (5nC) is separated in a column 
with 61 equilibrium stages. The feed molar flow rate is 100 km/h and 
the feed enters the equilibrium stage 23 (the condenser is stage 1). 
The design specifications are 1 mol% pure 5nC in the distillate and 1 
mol% pure 4nC in the bottoms of the tower, which are considered as 
the desired specifications. The reflux drum pressure is set at 4.5 
atmospheres to obtain a reflux drum temperature of 322 K so that 
cooling water can be used in the condenser. Figure 1 shows the 
flowsheet with its design conditions. The column diameter is 0.7145 
m, the reflux ratio is 1.323, and the boiler heat load is 0.758 MW. The 
tray pressure drop is specified as 0.1 𝑝𝑠𝑖 at each stage. With a refluxdrum pressure of 4.5 atm and 60 𝑝 in the column, the bottom pressure
of the tower is also 4.9 atm.
You can see the overal picture of this system in the next page.


## Location

- Iran, Tehran
- Sharif University of Technology
- Faculty of Chemical Engineering

---

## Introduction

Distillation is a common separation technique for liquid streams containing several components and is one of the most important unit operations in chemical manufacturing processes. Distillation is designed and controlled to produce a product stream of the required purity, whether for sale or for use in other chemical processes.

### Basic Principles

- **Separation Basis**: Distillation separates components of a liquid mixture by differences in boiling points.  
- **Component Terms**:
  - The component with a lower boiling point is called the *light component*.
  - The component with a higher boiling point is called the *heavy component*.
- Example: In a mixture of benzene and toluene, benzene is the light component, and toluene is the heavy component.

---

## Process Details

The following describes the general operation of a distillation tower:

1. **Vapor and Liquid Phases**:
   - Vapor flows upwards, while liquid flows downwards.
   - Mass transfer occurs between the two phases.

2. **Feed Location**:  
   Feed enters near the middle of the tower.  

3. **Key Components**:
   - **Reflux Drum**: Returns condensed liquid back to the tower.
   - **Reboiler**: Vaporizes a portion of the liquid from the bottom of the tower.

4. **Example**:
   - **System**: Mixture of 50% n-butane and 50% n-pentane.
   - **Column Specs**:
     - 61 equilibrium stages.
     - Feed enters at stage 23.
     - Reflux ratio: 1.323.
     - Boiler heat load: 0.758 MW.

---

## Control Strategies

The tower operation is maintained using control loops:

1. **Reboiler Heat Load Control**: Adjusts energy input for proper separation.
2. **Condenser Heat Load Control**: Ensures adequate cooling and condensation.
3. **Distillate Product Control**: Regulates product purity via reflux adjustments.
4. **Tower Downflow Control**: Balances liquid flow.
5. **Tower Return Flow Control**: Manages reflux flow.

---

## Modeling and Simulation

1. **Equations and Assumptions**: Write equilibrium relations and mass/energy balances.
2. **Open-Circuit Stability**: Check for steady state or instability.
3. **Control Design**:
   - Identify system dynamics.
   - Design controllers using PI (ITSE/IAE) methods.
   - Simulate responses to setpoint changes.

4. **Disturbance Rejection**:
   - Examine effects of ±10% variations in feed molar flow rate and temperature.

---

## Output Control Goal

Control the normal butane concentration in the distillate product to maintain 98% molar purity using equilibrium stage temperature control.

---

## References

1. Luyben, W.L., *Process Modeling, Simulation and Control for Chemical Engineers*.  
2. Luyben, W.L., B.D. Tyreus, and M.L. Luyben, *Plantwide Process Control*.  
3. Skogestad, S., *Chemical and Energy Process Engineering*.  
4. Luyben, W.L., *Distillation Design and Control Using Aspen Simulation*.
