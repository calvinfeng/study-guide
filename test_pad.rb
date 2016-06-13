
def rotate_matrix(mat)
  rotated_mat = []
  mat.each_index do |i|
    reversed_row = []
    (mat[i].length - 1).downto(0) do |j|
      reversed_row << mat[i][j]
    end
    rotated_mat << reversed_row
  end
  (0...rotated_mat.length).each do |i|
    (i...rotated_mat[i].length).each do |j|
      rotated_mat[i][j], rotated_mat[j][i] = rotated_mat[j][i], rotated_mat[i][j]
    end
  end

  rotated_mat
end

p rotate_matrix([[11,12,13],[21,22,23],[31,32,33]])
