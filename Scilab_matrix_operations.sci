 clc
 clear
 m=input("Enter number of rows: ")
 n=input("Enter number of columns: ")
 disp('enter first matrix');
 for i =1:m
 for j= 1 : n
 A(i,j) = input(’\’);
 
 end
 
 
 end
 disp(' enter second matrix ');
 for i =1:m
 
 
 
 for j= 1 : n
 B(i,j) = input(’\’);
 end
 
 end
 disp("Fist matrix is")
 disp(A)
 disp("Second matrix is")
 disp(B)
 disp("Sum of two matrix is")
 disp(A+B)
 disp("Difference of matrix A and B is")
 disp(A-B)
 // A*B only if inner dimensions agree
 if size(A, "c") == size(B, "r") then
 disp("Multiplication of A and B is: ");
 
 disp(A * B);
 else
 
 end
 // Simple stats
 disp("Max of A (overall):");
 disp(max(A));
 disp("A * B not computed: inner dimensions do not agree.");
 disp("Min of A (overall):");
 disp(min(A));
 disp("Mean of A (all entries):");
 disp(mean(A));
 // Square-matrix operations
  if m == n then

 disp("Inverse of A is: ");
 disp(inv(A));
 disp("Trace of A is: ");
 disp(trace(A));
 disp("Eigenvalues of A: ");
 
else
 disp(spec(A));
 disp("Inverse/trace/eigenvalues skipped: A is not square.");
end

disp("Transpose of A:");
disp(A’);
