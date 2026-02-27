public class Instruction {
    public String name;

    // R0 and R1 should only ever be numbers 0-3
    public int R0;
    public int R1;

    public Instruction(){
        name = null;
        R0 = 0;
        R1 = 0;
    }

    public Instruction(String name, int R0, int R1){
        this.name = name;
        this.R0 = R0;
        this.R1 = R1;
    }

    @Override
    public String toString(){
        return "{name=" + this.name +" R0=" + this.R0 + " R1=" + this.R1 + "}";
    }

    @Override
    public boolean equals(Object instruction){
        if (instruction instanceof Instruction){
            return this.name.equals(((Instruction) instruction).name) && this.R0 == ((Instruction) instruction).R0 && this.R1 == ((Instruction) instruction).R1;
        }
        return false;
    }
}