export type Checkpoint={id:string;name:string;place:string;lat:number;lon:number;xp:number;code:string;clue:string};
export const festival={id:"glow-eindhoven-2026",name:"GLOW Eindhoven 2026",theme:"CONNECT",currency:"Light",goal:1000,checkpoints:[
{id:"machina",name:"MACHINA",place:"18 Septemberplein",lat:51.4416,lon:5.4773,xp:150,code:"MACH26",clue:"Find the machine where the city begins to pulse."},
{id:"victoria",name:"Connection Signal",place:"Victoriapark",lat:51.4412,lon:5.4725,xp:150,code:"WEST26",clue:"Follow the pulse west into the park."},
{id:"inline",name:"In-Line v360",place:"Stadhuisplein",lat:51.4366,lon:5.4804,xp:250,code:"LINE26",clue:"Find the monumental signal near city hall."},
{id:"catharina",name:"Hidden Light",place:"Catharinakerk",lat:51.4378,lon:5.4782,xp:200,code:"HIDE26",clue:"Seek light beside an old landmark."},
{id:"market",name:"Final Connection",place:"Market Square",lat:51.4392,lon:5.4787,xp:250,code:"GLOW26",clue:"Complete the circuit where Eindhoven meets."}] satisfies Checkpoint[]};