class User < ApplicationRecord
  def add_provider_info(provider_key, key, value)
    new_provider_info = (provider_info.nil? ? {} : provider_info).symbolize_keys
    new_provider_info[provider_key][key] = value
    update(provider_info: new_provider_info)
  end

  def add_task_manager_info(task_manager_key, key, value)
    new_task_manager_info = (task_manager_info.nil? ? {} : task_manager_info).symbolize_keys
    new_task_manager_info[task_manager_key][key] = value
    update(task_manager_info: new_task_manager_info)
  end

  def add_repository_info(repository_key, key, value)
    new_repository_info = (repository_info.nil? ? {} : repository_info).symbolize_keys
    new_repository_info[repository_key][key] = value
    update(repository_info: new_repository_info)
  end
end
