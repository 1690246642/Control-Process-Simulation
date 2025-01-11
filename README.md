# Control-Process-Simulation
Simulation of an nC4/nC5 distillation column using MATLAB, focusing on stabilizing a non-ideal system with tuned controllers. Includes full code (some parts need improvement) and a PDF detailing goals, challenges, and comparisons to William Luyben's Simulink model. Updates planned for future versions

# Distillation Tower Project

**In the name of God, who is the merciful**

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
