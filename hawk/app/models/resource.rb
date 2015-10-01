# Copyright (c) 2009-2015 Tim Serong <tserong@suse.com>
# See COPYING for license.

class Resource < Record
  class CommandError < StandardError
  end

  attribute :object_type, Symbol
  attribute :state, Symbol
  attribute :managed, Boolean

  def object_type
    self.class.to_s.downcase
  end

  def state
    cib_by_id(id)[:state] || :unknown
  end

  def managed
    cib_by_id(id)[:is_managed] || false
  end

  def start!
    Invoker.instance.run(
      "crm",
      "resource",
      "start",
      id
    )
  end

  def stop!
    Invoker.instance.run(
      "crm",
      "resource",
      "stop",
      id
    )
  end

  def promote!
    Invoker.instance.run(
      "crm",
      "resource",
      "promote",
      id
    )
  end

  def demote!
    Invoker.instance.run(
      "crm",
      "resource",
      "demote",
      id
    )
  end

  def manage!
    Invoker.instance.run(
      "crm",
      "resource",
      "manage",
      id
    )
  end

  def unmanage!
    Invoker.instance.run(
      "crm",
      "resource",
      "unmanage",
      id
    )
  end

  def unmigrate!
    Invoker.instance.run(
      "crm",
      "resource",
      "unmigrate",
      id
    )
  end

  def migrate!(node = nil)
    Invoker.instance.run(
      "crm",
      "resource",
      "migrate",
      id,
      node.to_s
    )
  end

  def cleanup!(node = nil)
    Invoker.instance.run(
      "crm",
      "resource",
      "cleanup",
      id,
      node.to_s
    )
  end

  class << self
    def all
      super(true)
    end

    def cib_type_fetch
      "configuration//*[self::resources or self::tags]/*"
    end
  end

  protected

  def cib_by_id(id)
    current_cib.resources_by_id[id] || {}
  end
end
