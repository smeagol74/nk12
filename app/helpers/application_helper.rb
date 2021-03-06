module ApplicationHelper
  def suckerfish(node)
    fuc = lambda do |nodes|
      return "" if nodes.empty?
      return "<ul>" +
        nodes.inject("") do |string, (node, children)|
          string + "<li rel='#{node.id}'>" +
          node.name+
          fuc.call(children) +
          "</li>"
        end +
        "</ul>"
    end
    fuc.call(node.descendants.arrange)
  end

  def vds(i=0, election_id=1)
    VOTING_DICTIONARY_SHORT[election_id][i]
  end
end
