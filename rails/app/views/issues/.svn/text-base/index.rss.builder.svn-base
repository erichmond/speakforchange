<% content_for :headtag do %>
  <%= render :partial => 'shared/page_player' %>
<% end %>
<h2>Issues</h2>

<p>
Give voice to your opinion about the important issues we face today.
Issues are assigned extensions that you can dial when calling our phone number.
</p>

<p>To create an issue, <%= link_to "click here", new_issue_path %>.</p>


<%= will_paginate @issues %>

<table>
  <thead>
    <th>Issue</th>
    <th>Created</th>
    <th>Extension</th>
    <th>Messages</th>
  </thead>
  <tbody>
    <% @issues.each do |issue| %>
      <tr class="<%=cycle('odd', 'even')%>">
        <td>
          <%= link_to(issue.title, issue) %>
        </td>
        <td>
          <%= time_ago_in_words issue.created_at %> ago
        </td>
        <td>
          x<%= issue.extension%>#
        </td>
        <td class='msgCol'>
          <% if issue.deliveries_count > 0 %>
            <%= link_to issue.deliveries_count, issue %>
          <% else %>
            <%= issue.deliveries_count %>
          <% end %>
        </td>
      </tr>
    <% end %>
  </tbody>
</table>


<%= will_paginate @issues %>
