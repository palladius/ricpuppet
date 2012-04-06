####################################################################
# This is a test conffile for Puppet module: 
# <%= puppet_module rescue "Exception: #{$!}" %>
####################################################################

<%= log %> {
<% options.each do |opt| -%> <%= opt %>
<% end -%>
<% if postrotate != "NONE" -%> postrotate 
<% end -%>
<% if postrotate != "NONE" -%> <%= postrotate %> 
<% end -%>
<% if postrotate != "NONE" -%> endscript 
<% end -%>
}