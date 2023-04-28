
import java.awt.GridBagLayout;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JPanel;
import org.jpl7.Query;
import org.jpl7.Term;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author menna
 */
public class Uninformed extends SearchStrategy{

    public Uninformed(GUI g) {
        super(g);
    }


    @Override
    String generateInputQuery() {
        String query="uSearch(["; int rows = (int) gui.getRows().getValue(), cols= (int) gui.getCols().getValue();
        JButton buttons[][] = gui.getBtns();
        for(int i=0;i<rows;i++){
            query+="[";
            for(int j=0;j<cols;j++){
                //char boardItem = 'O'; 
              //  System.out.println( (buttons[i][j].getIcon()==null)?"null":"NOTnull");

                query+=(buttons[i][j].getIcon() == null)?"*":"'O'";
                query+=(j<cols-1)?",":"";
            }
            query+=(i<rows -1)?"],":"]";
        }
    return query+"],["+rows+","+cols+"],[],X)";
   
    }

    @Override
    String[] generateSolution() {
         //   outputPanel.removeAll();
     //   System.out.print(generateInputQuery("uSearch));
     // Query q = new Query("consult('file1.pl'), consult('file2.pl')");
        Query q = new Query("consult('../Prolog implementation/board.pl'),consult('../Prolog implementation/uninformed.pl')"); 
     //   int rows = (int) Rows.getValue(), cols= (int) Cols.getValue();
       q.hasSolution();
        q= new Query(generateInputQuery());
        Map<String,Term>[] solutions = q.allSolutions(); 
        Set<String> ResultsSet = new HashSet<String>(); 
        for (Map<String, Term> sol :solutions) {
        String s = (sol.get("X").toString()); ResultsSet.add(s); }
       return ResultsSet.toArray(new String[0]);
         
    }
    
}
