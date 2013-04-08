require 'arel/visitors/to_sql'

module Arel
  module Visitors
    class SybaseASE < Arel::Visitors::ToSql

      # Sybase doesn't recognize LIMIT keyword but uses
      # a TOP one instead.

      def visit_Arel_Nodes_Top o
        "TOP #{visit o.expr}"
      end

      def visit_Arel_Nodes_Offset o
        ""
      end

      def visit_Arel_Nodes_Limit o
        ""
      end

    end
    Arel::Visitors::VISITORS['sybase'] = Arel::Visitors::SybaseASE
  end
end